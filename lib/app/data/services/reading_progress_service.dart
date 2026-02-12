// lib/app/data/services/reading_progress_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minh_nguyet_truyen/app/domain/models/reading_progress.dart';
import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';

class ReadingProgressService {
  static const String _keyReadingProgress = 'reading_progress';
  static const int _maxProgress = 50;
  final SharedPreferences _prefs;

  ReadingProgressService(this._prefs);

  // Lưu tiến độ đọc với tự động xóa cũ
  Future<bool> saveProgress({
    required String storyId,
    required String storyName,
    String? storyThumbnail,
    required ChapterEntity chapter,
    required int currentChapterPage,
    required int totalChapterPages,
    required bool isFirstChapter,
    required bool isLastChapter,
  }) async {
    final progress = ReadingProgress(
      storyId: storyId,
      storyName: storyName,
      chapter: chapter,
      currentChapterPage: currentChapterPage,
      isFirstChapter: isFirstChapter,
      isLastChapter: isLastChapter,
      lastReadAt: DateTime.now(),
    );

    final allProgress = await getAllProgress();

    // Xóa tiến độ cũ của truyện này (nếu có)
    allProgress.removeWhere((p) => p.storyId == storyId);

    // Thêm tiến độ mới lên đầu
    allProgress.insert(0, progress);

    // Tự động giới hạn tối đa 50 (FIFO)
    if (allProgress.length > _maxProgress) {
      allProgress.removeRange(_maxProgress, allProgress.length);
    }

    return await _saveAllProgress(allProgress);
  }

  // Lấy tiến độ đọc của 1 truyện
  Future<ReadingProgress?> getProgress(String comicId) async {
    final allProgress = await getAllProgress();
    try {
      return allProgress.firstWhere((p) => p.storyId == comicId);
    } catch (e) {
      return null;
    }
  }

  // Lấy tất cả tiến độ đọc (sắp xếp theo thời gian mới nhất)
  Future<List<ReadingProgress>> getAllProgress() async {
    final String? jsonString = _prefs.getString(_keyReadingProgress);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    final progressList =
        jsonList.map((json) => ReadingProgress.fromJson(json)).toList();

    // Sắp xếp theo thời gian đọc (mới nhất lên đầu)
    progressList.sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));

    return progressList;
  }

  // Lấy danh sách truyện đã đọc gần đây (giới hạn số lượng)
  Future<List<ReadingProgress>> getRecentlyRead({int limit = 10}) async {
    final allProgress = await getAllProgress();
    return allProgress.take(limit).toList();
  }

  // Xóa tiến độ đọc của 1 truyện
  Future<bool> removeProgress(String comicId) async {
    final allProgress = await getAllProgress();
    allProgress.removeWhere((p) => p.storyId == comicId);
    return await _saveAllProgress(allProgress);
  }

  // Xóa tất cả tiến độ đọc
  Future<bool> clearAllProgress() async {
    return await _prefs.remove(_keyReadingProgress);
  }

  // Lưu tất cả tiến độ
  Future<bool> _saveAllProgress(List<ReadingProgress> progressList) async {
    final jsonList = progressList.map((p) => p.toJson()).toList();
    final jsonString = json.encode(jsonList);
    return await _prefs.setString(_keyReadingProgress, jsonString);
  }
}
