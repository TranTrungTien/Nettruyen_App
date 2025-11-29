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
      super.otherNames,
      super.totalViews,
      super.followers,
      super.chapters,
      super.genres,
      super.isTrending,
      super.latestChapter,
      super.shortDescription,
      super.updatedAt,
      super.totalChapterPages,
      super.totalChapters});

  factory ComicModel.fromEntity(ComicEntity entity) {
    return ComicModel(
        id: entity.id,
        title: entity.title,
        thumbnail: entity.thumbnail,
        description: entity.description,
        authors: entity.authors,
        status: entity.status,
        otherNames: entity.otherNames,
        totalViews: entity.totalViews,
        followers: entity.followers,
        chapters: entity.chapters,
        genres: entity.genres,
        isTrending: entity.isTrending,
        latestChapter: entity.latestChapter,
        shortDescription: entity.shortDescription,
        updatedAt: entity.updatedAt,
        totalChapterPages: entity.totalChapterPages,
        totalChapters: entity.totalChapterPages);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'description': description,
      'authors': authors,
      'status': status,
      'otherNames': otherNames,
      'totalViews': totalViews,
      'followers': followers,
      'isTrending': isTrending,
      'latestChapter': latestChapter != null
          ? ChapterModel.fromEntity(latestChapter!).toMap()
          : null,
      'shortDescription': shortDescription,
      'updatedAt': updatedAt,
      'totalChapterPages': totalChapterPages,
      'totalChapters': totalChapters,
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
      otherNames: List.empty(),
      totalViews: map['totalViews'].toString(),
      followers: map['followers'].toString(),
      isTrending: map['isTrending'],
      latestChapter: map['latestChapter'] != null
          ? ChapterModel.fromMap(map['latestChapter'])
          : null,
      shortDescription: map['shortDescription'],
      updatedAt: map['updatedAt'],
      chapters: chapters,
      genres: genres,
      totalChapterPages: map['totalChapterPages'],
      totalChapters: map['totalChapters'],
    );
  }

  factory ComicModel.fromJson(String source) =>
      ComicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
