import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:minh_nguyet_truyen/app/domain/models/genre.dart';

class GenreState extends Equatable {
  final List<GenreEntity>? listGenre;
  final DioException? error;
  const GenreState({
    this.listGenre,
    this.error,
  });

  @override
  List<Object?> get props => [listGenre, error];

  GenreState copyWith({
    List<GenreEntity>? listGenre,
    DioException? error,
  }) {
    return GenreState(
      listGenre: listGenre ?? this.listGenre,
      error: error ?? this.error,
    );
  }
}

class GenreLoading extends GenreState {
  const GenreLoading();
}

class GenreSuccessfull extends GenreState {
  const GenreSuccessfull({super.listGenre});
}

class GenreFailed extends GenreState {
  const GenreFailed({super.error});
}
