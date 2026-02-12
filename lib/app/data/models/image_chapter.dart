import 'dart:convert';
import 'package:minh_nguyet_truyen/app/domain/models/image_chapter.dart';

class ImageChapterModel extends ImageChapterEntity {
  const ImageChapterModel({super.backupSrc, super.page, super.src});

  factory ImageChapterModel.fromEntity(ImageChapterEntity entity) {
    return ImageChapterModel(
        backupSrc: entity.backupSrc, page: entity.page, src: entity.src);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'src': src,
      'backupSrc': backupSrc,
    };
  }

  factory ImageChapterModel.fromMap(Map<String, dynamic> map) {
    return ImageChapterModel(
      page: map['page'],
      src: map['src'],
      backupSrc: map['backupSrc'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageChapterModel.fromJson(String source) =>
      ImageChapterModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
