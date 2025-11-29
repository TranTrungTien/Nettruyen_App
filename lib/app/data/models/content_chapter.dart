import 'dart:convert';

import 'package:nettruyen/app/data/models/chapter.dart';
import 'package:nettruyen/app/domain/models/content_chapter.dart';

class ContentChapterModel extends ContentChapterEntity {
  ContentChapterModel(
      {super.chapterName, super.chapters, super.comicName, super.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chapters':
          chapters?.map((x) => ChapterModel.fromEntity(x).toMap()).toList(),
      'content': content,
      'chapterName': chapterName,
      'comicName': comicName,
    };
  }

  factory ContentChapterModel.fromMap(Map<String, dynamic> map) {
    return ContentChapterModel(
      chapters: map['chapters'] != null
          ? List<ChapterModel>.from(
              (map['chapters'] as List<dynamic>).map<ChapterModel?>(
                (x) => ChapterModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      content: map['content'],
      chapterName: map['chapterName'],
      comicName: map['comicName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContentChapterModel.fromJson(String source) =>
      ContentChapterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
