import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';

class ChapterPerPageState extends Equatable {
  final DioException? error;
  const ChapterPerPageState({
    this.error,
  });

  @override
  List<Object?> get props => [error];

  ChapterPerPageState copyWith({
    List<ChapterEntity>? chapters,
    DioException? error,
  }) {
    return ChapterPerPageState(
      error: error ?? this.error,
    );
  }
}

class ChapterPerPageSuccessfull extends ChapterPerPageState {
  final List<ChapterEntity> chapters;
  final int page;
  const ChapterPerPageSuccessfull(this.chapters, this.page);
}

class ChapterPerPageLoading extends ChapterPerPageState {
  const ChapterPerPageLoading();
}

class ChapterPerPageFailed extends ChapterPerPageState {
  const ChapterPerPageFailed({super.error});
}
