import 'dart:convert';

import 'package:minh_nguyet_truyen/app/domain/models/genre.dart';

class GenreModel extends GenreEntity {
  const GenreModel({super.id, super.name, super.description});

  factory GenreModel.fromEntity(GenreEntity entity) {
    return GenreModel(
        id: entity.id, name: entity.name, description: entity.description);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory GenreModel.fromMap(Map<String, dynamic> map) {
    return GenreModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenreModel.fromJson(String source) =>
      GenreModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
