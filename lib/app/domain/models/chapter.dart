import 'package:equatable/equatable.dart';

class ChapterEntity extends Equatable {
  final String id;
  final String? name;
  final String? url;
  final int? chapterNumber;
  final DateTime? updatedAt;

  const ChapterEntity({
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

  @override
  String toString() {
    return 'Chapter(id: $id, name: $name)';
  }
}
