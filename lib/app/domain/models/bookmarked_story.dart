// lib/app/domain/models/bookmarked_story.dart
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';

class BookmarkedStory {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final DateTime bookmarkedAt;
  final DateTime? lastReadAt;
  final List<String> genres;
  final String? status;

  BookmarkedStory({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.bookmarkedAt,
    this.lastReadAt,
    this.genres = const [],
    this.status,
  });

  // Convert từ ComicEntity sang BookmarkedStory
  factory BookmarkedStory.fromComic(ComicEntity comic) {
    List<String> genres = comic.genres != null
        ? comic.genres!.map((genre) {
            return genre.name ?? '';
          }).toList()
        : List.empty();

    return BookmarkedStory(
      id: comic.id ?? '',
      title: comic.title ?? '',
      author: comic.authors ?? 'Đang cập nhật',
      description: comic.description ?? '',
      coverUrl: comic.thumbnail ?? '',
      bookmarkedAt: DateTime.now(),
      genres: genres,
      status: comic.status,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'bookmarkedAt': bookmarkedAt.toIso8601String(),
      'lastReadAt': lastReadAt?.toIso8601String(),
      'genres': genres,
      'status': status,
    };
  }

  // From JSON
  factory BookmarkedStory.fromJson(Map<String, dynamic> json) {
    return BookmarkedStory(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      bookmarkedAt: DateTime.parse(json['bookmarkedAt']),
      lastReadAt: json['lastReadAt'] != null
          ? DateTime.parse(json['lastReadAt'])
          : null,
      genres: List<String>.from(json['genres'] ?? []),
      status: json['status'],
    );
  }

  // Copy with
  BookmarkedStory copyWith({
    DateTime? lastReadAt,
  }) {
    return BookmarkedStory(
      id: id,
      title: title,
      author: author,
      description: description,
      coverUrl: coverUrl,
      bookmarkedAt: bookmarkedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      genres: genres,
      status: status,
    );
  }
}
