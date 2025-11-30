// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';

class ComicListEntity {
  List<ComicEntity>? comics;
  int? totalPages;
  int? currentPage;
  ComicListEntity({
    this.comics,
    this.totalPages,
    this.currentPage,
  });

  ComicListEntity copyWith({
    List<ComicEntity>? comics,
    int? totalPages,
    int? currentPage,
  }) {
    return ComicListEntity(
      comics: comics ?? this.comics,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.totalPages,
    );
  }

  @override
  String toString() =>
      'ComicListEntity(comics: $comics, total_pages: $totalPages, current_page: $currentPage)';
}
