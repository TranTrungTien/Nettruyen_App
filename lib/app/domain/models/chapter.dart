// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ChapterEntity extends Equatable {
  String id;
  String? name;
  String? url;
  int? chapterNumber;
  DateTime? updatedAt;

  ChapterEntity({
    required this.id,
    this.name,
    this.url,
    this.chapterNumber,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, url, chapterNumber, updatedAt];

  @override
  bool get stringify => true;
}
