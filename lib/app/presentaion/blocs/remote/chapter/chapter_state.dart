import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/domain/models/content_chapter.dart';

class ChapterState extends Equatable {
  final ContentChapterEntity? contentChapter;
  final DioException? error;
  const ChapterState({
    this.contentChapter,
    this.error,
  });

  @override
  List<Object?> get props => [contentChapter, error];

  ChapterState copyWith({
    ContentChapterEntity? contentChapter,
    ComicEntity? comic,
    DioException? error,
  }) {
    return ChapterState(
      contentChapter: contentChapter ?? this.contentChapter,
      error: error ?? this.error,
    );
  }
}

class ChapterSuccessfull extends ChapterState {
  const ChapterSuccessfull({super.contentChapter});
}

class ChapterLoading extends ChapterState {
  const ChapterLoading();
}

class ChapterFailed extends ChapterState {
  const ChapterFailed({super.error});
}
