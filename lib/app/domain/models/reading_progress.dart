import 'dart:convert';

import 'package:minh_nguyet_truyen/app/data/models/chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';

class ReadingProgress {
  final String storyId;
  final String storyName;
  final ChapterEntity chapter;
  final int currentChapterPage;
  final bool isFirstChapter;
  final bool isLastChapter;
  final DateTime lastReadAt;

  ReadingProgress({
    required this.storyId,
    required this.storyName,
    required this.chapter,
    required this.currentChapterPage,
    required this.isFirstChapter,
    required this.isLastChapter,
    required this.lastReadAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'storyName': storyName,
      'chapter': ChapterModel.fromEntity(chapter).toMap(),
      'currentChapterPage': currentChapterPage,
      'isFirstChapter': isFirstChapter,
      'isLastChapter': isLastChapter,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    final rawChapter = json['chapter'];
    Map<String, dynamic> chapterMap;

    if (rawChapter is String) {
      chapterMap = jsonDecode(rawChapter);
    } else if (rawChapter is Map) {
      chapterMap = Map<String, dynamic>.from(rawChapter);
    } else {
      throw Exception('Invalid chapter data');
    }

    return ReadingProgress(
      storyId: json['storyId'] ?? '',
      storyName: json['storyName'] ?? '',
      chapter: ChapterModel.fromMap(chapterMap),
      currentChapterPage: json['currentChapterPage'] ?? 1,
      isFirstChapter: json['isFirstChapter'] ?? false,
      isLastChapter: json['isLastChapter'] ?? false,
      lastReadAt: DateTime.parse(json['lastReadAt']),
    );
  }

  factory ReadingProgress.fromComicAndChapter({
    required String storyId,
    required String storyName,
    required ChapterEntity chapter,
    required int currentChapterPage,
    required int totalChapterPages,
    required bool isFirstChapter,
    required bool isLastChapter,
  }) {
    return ReadingProgress(
      storyId: storyId,
      storyName: storyName,
      chapter: chapter,
      currentChapterPage: currentChapterPage,
      isFirstChapter: isFirstChapter,
      isLastChapter: isLastChapter,
      lastReadAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ReadingProgress('
        'storyId: $storyId, '
        'storyName: $storyName, '
        'chapter: ${chapter.toString()}, '
        'currentChapterPage: $currentChapterPage, '
        'isFirstChapter: $isFirstChapter, '
        'isLastChapter: $isLastChapter, '
        'lastReadAt: $lastReadAt'
        ')';
  }
}
