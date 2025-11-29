// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/image_chapter.dart';

// ignore: must_be_immutable
class ContentChapterEntity {
  List<ChapterEntity>? chapters;
  String? content;
  String? chapterName;
  String? comicName;
  ContentChapterEntity({
    this.chapters,
    this.content,
    this.chapterName,
    this.comicName,
  });

  ContentChapterEntity copyWith({
    List<ChapterEntity>? chapters,
    List<ImageChapterEntity>? images,
    String? chapterName,
    String? comicName,
  }) {
    return ContentChapterEntity(
      chapters: chapters ?? this.chapters,
      content: content ?? this.content,
      chapterName: chapterName ?? this.chapterName,
      comicName: comicName ?? this.comicName,
    );
  }

  @override
  String toString() {
    return 'ContentChapterEntity(chapters: $chapters, content: $content, chapter_name: $chapterName, comic_name: $comicName)';
  }
}
