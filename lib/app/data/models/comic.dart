import 'dart:convert';

import 'package:nettruyen/app/data/models/chapter.dart';
import 'package:nettruyen/app/data/models/genre.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/domain/models/genre.dart';

// ignore: must_be_immutable
class ComicModel extends ComicEntity {
  ComicModel(
      {super.id,
      super.title,
      super.thumbnail,
      super.description,
      super.authors,
      super.status,
      // ignore: non_constant_identifier_names
      super.other_names,
      // ignore: non_constant_identifier_names
      super.total_views,
      super.followers,
      super.chapters,
      super.genres,
      super.is_trending,
      super.last_chapter,
      super.short_description,
      super.updated_at,
      super.totalChapterPages});

  factory ComicModel.fromEntity(ComicEntity entity) {
    return ComicModel(
        id: entity.id,
        title: entity.title,
        thumbnail: entity.thumbnail,
        description: entity.description,
        authors: entity.authors,
        status: entity.status,
        other_names: entity.other_names,
        total_views: entity.total_views,
        followers: entity.followers,
        chapters: entity.chapters,
        genres: entity.genres,
        is_trending: entity.is_trending,
        last_chapter: entity.last_chapter,
        short_description: entity.short_description,
        updated_at: entity.updated_at,
        totalChapterPages: entity.totalChapterPages);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'description': description,
      'authors': authors,
      'status': status,
      'other_names': other_names,
      'total_views': total_views,
      'followers': followers,
      'is_trending': is_trending,
      'last_chapter': last_chapter != null
          ? ChapterModel.fromEntity(last_chapter!).toMap()
          : null,
      'short_description': short_description,
      'updated_at': updated_at,
      'totalChapterPages': totalChapterPages,
      'chapters':
          chapters?.map((x) => ChapterModel.fromEntity(x).toMap()).toList(),
      'genres': genres?.map((x) => GenreModel.fromEntity(x).toMap()).toList(),
    };
  }

  factory ComicModel.fromMap(Map<String, dynamic> map) {
    String authors = '';
    if (map['authors'] != null && map['authors'].isNotEmpty) {
      authors = List<String>.from(map['authors']).join(', ');
    } else {
      authors = '';
    }

    List<GenreEntity> genres = [];
    if (map['genres'] != null && map['genres'].isNotEmpty) {
      genres = (map['genres'] as List)
          .map((g) => GenreModel.fromMap(g as Map<String, dynamic>))
          .toList();
    }

    List<ChapterEntity> chapters = [];
    if (map['chapters'] != null && map['chapters'].isNotEmpty) {
      chapters = (map['chapters'] as List)
          .map((g) => ChapterModel.fromMap(g as Map<String, dynamic>))
          .toList();
    }

    return ComicModel(
      id: map["id"],
      title: map["title"],
      thumbnail: map['thumbnail'],
      description: map['description'],
      authors: authors,
      status: map['status'],
      other_names: List.empty(),
      total_views: map['total_views'].toString(),
      followers: map['followers'].toString(),
      is_trending: map['is_trending'],
      last_chapter: null,
      short_description: map['short_description'],
      updated_at: map['updated_at'],
      chapters: chapters,
      genres: genres,
      totalChapterPages: map['total_chapter_pages'],
    );
  }

  factory ComicModel.fromJson(String source) =>
      ComicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
