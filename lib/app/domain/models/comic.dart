// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/genre.dart';

// ignore: must_be_immutable
class ComicEntity extends Equatable {
  String? id;
  String? title;
  String? thumbnail;
  String? description;
  String? shortDescription;
  bool? isTrending = false;
  String? updatedAt;
  String? authors;
  String? status;
  List<String>? otherNames;
  String? totalViews;
  String? followers;
  List<ChapterEntity>? chapters;
  List<GenreEntity>? genres;
  ChapterEntity? latestChapter;
  int? totalChapterPages;
  int? totalChapters;

  ComicEntity(
      {this.id,
      this.title,
      this.thumbnail,
      this.description,
      this.shortDescription,
      this.isTrending,
      this.updatedAt,
      this.authors,
      this.status,
      this.otherNames,
      this.totalViews,
      this.followers,
      this.chapters,
      this.genres,
      this.latestChapter,
      this.totalChapterPages,
      this.totalChapters});

  @override
  List<Object?> get props => [id];

  ComicEntity copyWith(
      {String? id,
      String? title,
      String? thumbnail,
      String? description,
      String? shortDescription,
      bool? isTrending,
      String? updatedAt,
      String? authors,
      String? status,
      List<String>? otherNames,
      String? totalViews,
      String? followers,
      List<ChapterEntity>? chapters,
      List<GenreEntity>? genres,
      ChapterEntity? latestChapter,
      int? totalChapterPages,
      int? totalChapters}) {
    return ComicEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        thumbnail: thumbnail ?? this.thumbnail,
        description: description ?? this.description,
        shortDescription: shortDescription ?? this.shortDescription,
        isTrending: isTrending ?? this.isTrending,
        updatedAt: updatedAt ?? this.updatedAt,
        authors: authors ?? this.authors,
        status: status ?? this.status,
        otherNames: otherNames ?? this.otherNames,
        totalViews: totalViews ?? this.totalViews,
        followers: followers ?? this.followers,
        chapters: chapters ?? this.chapters,
        genres: genres ?? this.genres,
        latestChapter: latestChapter ?? this.latestChapter,
        totalChapterPages: totalChapterPages ?? 0,
        totalChapters: totalChapters ?? 0);
  }

  @override
  bool get stringify => true;
}
