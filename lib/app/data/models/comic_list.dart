import 'dart:convert';

import 'package:minh_nguyet_truyen/app/data/models/comic.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic_list.dart';

class ComicListModel extends ComicListEntity {
  ComicListModel({super.comics, super.currentPage, super.totalPages});

  factory ComicListModel.fromEntity(ComicListEntity entity) {
    return ComicListModel(
        comics: entity.comics,
        currentPage: entity.currentPage,
        totalPages: entity.totalPages);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comics': comics?.map((x) => ComicModel.fromEntity(x).toMap()).toList(),
      'totalPages': totalPages,
      'currentPage': currentPage,
    };
  }

  factory ComicListModel.fromMap(Map<String, dynamic> map) {
    return ComicListModel(
      comics: map['comics'] != null
          ? List<ComicModel>.from(
              (map['comics'] as List<dynamic>).map<ComicModel?>(
                (x) => ComicModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      totalPages: map['totalPages'],
      currentPage: map['currentPage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ComicListModel.fromJson(String source) =>
      ComicListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
