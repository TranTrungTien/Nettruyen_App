import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/domain/usecases/remote/get_chapter_per_page_usecase.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/chapter_per_page/chapter_per_page_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/chapter_per_page/chapter_per_page_state.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class ChapterPerPageBloc
    extends Bloc<GetChapterPerPageEvent, ChapterPerPageState> {
  GetChapterPerPageUsecase usecaseGetChapterPerPage;
  ChapterPerPageBloc(this.usecaseGetChapterPerPage)
      : super(ChapterPerPageState()) {
    on<GetChapterPerPageEvent>(onGetChapterPerPageEvent);
  }

  FutureOr<void> onGetChapterPerPageEvent(
      GetChapterPerPageEvent event, Emitter<ChapterPerPageState> emit) async {
    emit(ChapterPerPageLoading());
    final dataState =
        await usecaseGetChapterPerPage.call(id: event.slug, page: event.page);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(ChapterPerPageSuccessfull(dataState.data!, event.page));
    } else {
      emit(ChapterPerPageFailed(error: dataState.error));
    }
  }
}
