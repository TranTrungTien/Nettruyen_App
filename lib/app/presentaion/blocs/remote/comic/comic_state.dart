import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic_list.dart';
import 'package:minh_nguyet_truyen/app/domain/models/content_chapter.dart';

class ComicState extends Equatable {
  final ComicListEntity? listComic;
  final ComicEntity? comic;
  final ContentChapterEntity? contentChapter;
  final DioException? error;
  const ComicState({
    this.listComic,
    this.comic,
    this.contentChapter,
    this.error,
  });

  @override
  List<Object?> get props => [listComic, comic, contentChapter, error];

  ComicState copyWith({
    ComicListEntity? listComic,
    ComicEntity? comic,
    ContentChapterEntity? contentChapter,
    DioException? error,
  }) {
    return ComicState(
      listComic: listComic ?? this.listComic,
      comic: comic ?? this.comic,
      contentChapter: contentChapter ?? this.contentChapter,
      error: error ?? this.error,
    );
  }
}

class ComicLoading extends ComicState {
  const ComicLoading();
}

class ComicSuccesfull extends ComicState {
  const ComicSuccesfull({super.listComic, super.comic, super.contentChapter});
}

class ComicFailed extends ComicState {
  const ComicFailed({required DioException error}) : super(error: error);
}

class ComicInitial extends ComicState {}
