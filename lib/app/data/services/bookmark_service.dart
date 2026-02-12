// lib/app/data/services/bookmark_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minh_nguyet_truyen/app/domain/models/bookmarked_story.dart';

class BookmarkService {
  static const String _keyBookmarks = 'bookmarked_stories';
  static const int _maxBookmarks = 20;
  final SharedPreferences _prefs;

  BookmarkService(this._prefs);

  // Lấy tất cả bookmark
  Future<List<BookmarkedStory>> getBookmarks() async {
    final String? jsonString = _prefs.getString(_keyBookmarks);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => BookmarkedStory.fromJson(json)).toList();
  }

  // Thêm bookmark
  Future<bool> addBookmark(BookmarkedStory story) async {
    final bookmarks = await getBookmarks();

    // Kiểm tra đã tồn tại chưa
    if (bookmarks.any((b) => b.id == story.id)) {
      return false; // Đã có rồi
    }

    // Thêm vào đầu danh sách
    bookmarks.insert(0, story);

    // Giới hạn tối đa 20
    if (bookmarks.length > _maxBookmarks) {
      bookmarks.removeRange(_maxBookmarks, bookmarks.length);
    }

    return await _saveBookmarks(bookmarks);
  }

  // Xóa bookmark
  Future<bool> removeBookmark(String storyId) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.id == storyId);
    return await _saveBookmarks(bookmarks);
  }

  // Kiểm tra đã bookmark chưa
  Future<bool> isBookmarked(String storyId) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b.id == storyId);
  }

  // Cập nhật thời gian đọc
  Future<bool> updateLastRead(String storyId) async {
    final bookmarks = await getBookmarks();
    final index = bookmarks.indexWhere((b) => b.id == storyId);

    if (index != -1) {
      bookmarks[index] = bookmarks[index].copyWith(
        lastReadAt: DateTime.now(),
      );
      return await _saveBookmarks(bookmarks);
    }
    return false;
  }

  // Lấy số lượng bookmark hiện tại
  Future<int> getBookmarkCount() async {
    final bookmarks = await getBookmarks();
    return bookmarks.length;
  }

  // Kiểm tra còn chỗ không
  Future<bool> canAddMore() async {
    final count = await getBookmarkCount();
    return count < _maxBookmarks;
  }

  // Lưu vào SharedPreferences
  Future<bool> _saveBookmarks(List<BookmarkedStory> bookmarks) async {
    final jsonList = bookmarks.map((b) => b.toJson()).toList();
    final jsonString = json.encode(jsonList);
    return await _prefs.setString(_keyBookmarks, jsonString);
  }
}
