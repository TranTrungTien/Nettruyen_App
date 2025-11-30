import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/domain/usecases/remote/get_comics_search_usecase.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class SearchComicBloc extends Bloc<ComicEvent, ComicState> {
  GetComicsSearchUsecase usecase;

  SearchComicBloc(this.usecase) : super(ComicInitial()) {
    on<GetComicsSearchEvent>(onSearch);
  }

  Future<FutureOr<void>> onSearch(
      GetComicsSearchEvent event, Emitter<ComicState> emit) async {
    emit(ComicLoading());
    final dataState = await usecase.call(page: event.page, query: event.query);
    if (dataState is DataSuccess) {
      emit(ComicSuccesfull(listComic: dataState.data));
    } else {
      emit(ComicFailed(error: dataState.error!));
    }
  }
}
