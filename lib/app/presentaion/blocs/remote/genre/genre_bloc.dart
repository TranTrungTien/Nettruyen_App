import 'dart:async';

import 'package:dio/dio.dart';
import 'package:minh_nguyet_truyen/app/domain/usecases/remote/get_genres_usecase.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/genre/genre_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/genre/genre_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GetGenresUsecase usecase;
  GenreBloc(this.usecase) : super(GenreLoading()) {
    on<GetGenresEvent>(onGet);
  }

  Future<FutureOr<void>> onGet(
      GetGenresEvent event, Emitter<GenreState> emit) async {
    emit(GenreLoading());
    final dataState = await usecase.call();
    if (dataState is DataSuccess) {
      emit(GenreSuccessfull(listGenre: dataState.data));
    } else if (dataState is DataFailed) {
      emit(GenreFailed(error: dataState.error));
    } else {
      emit(GenreFailed(
          error: DioException(
              requestOptions: RequestOptions(),
              message: "Không xác định lỗi",
              error: 404)));
    }
  }
}
