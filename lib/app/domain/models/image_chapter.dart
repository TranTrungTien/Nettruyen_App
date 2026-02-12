// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ImageChapterEntity extends Equatable {
  final int? page;
  final String? src;
  final String? backupSrc;
  const ImageChapterEntity({
    this.page,
    this.src,
    this.backupSrc,
  });

  @override
  List<Object?> get props => [page, src, backupSrc];

  ImageChapterEntity copyWith({
    int? page,
    String? src,
    String? backupSrc,
  }) {
    return ImageChapterEntity(
      page: page ?? this.page,
      src: src ?? this.src,
      backupSrc: backupSrc ?? this.backupSrc,
    );
  }

  @override
  bool get stringify => true;
}
