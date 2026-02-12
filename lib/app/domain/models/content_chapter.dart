import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/models/image_chapter.dart';

class ContentChapterEntity {
  final List<ChapterEntity>? chapters;
  final String? content;
  final String? chapterName;
  final String? comicName;
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
