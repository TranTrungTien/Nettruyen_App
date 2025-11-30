// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';

class ChapterPerPageState extends Equatable {
  DioException? error;
  ChapterPerPageState({
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
  ChapterPerPageSuccessfull(this.chapters, this.page);
}

class ChapterPerPageLoading extends ChapterPerPageState {
  ChapterPerPageLoading();
}

class ChapterPerPageFailed extends ChapterPerPageState {
  ChapterPerPageFailed({super.error});
}
