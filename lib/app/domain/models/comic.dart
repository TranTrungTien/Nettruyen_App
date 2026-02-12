import 'package:equatable/equatable.dart';

import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/models/genre.dart';

class ComicEntity extends Equatable {
  final String? id;
  final String? title;
  final String? thumbnail;
  final String? description;
  final String? authors;
  final String? status;
  final List<String>? otherNames;
  final String? totalViews;
  final String? followers;
  final List<ChapterEntity>? chapters;
  final List<GenreEntity>? genres;
  final bool? isTrending;
  final ChapterEntity? latestChapter;
  final String? shortDescription;
  final String? updatedAt;
  final int? totalChapterPages;
  final int? totalChapters;

  const ComicEntity(
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
