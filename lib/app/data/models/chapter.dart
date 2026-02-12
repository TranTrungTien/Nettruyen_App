import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.name,
  });

  factory ChapterModel.fromEntity(ChapterEntity entity) {
    return ChapterModel(
      id: entity.id,
      name: entity.name,
    );
  }

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
