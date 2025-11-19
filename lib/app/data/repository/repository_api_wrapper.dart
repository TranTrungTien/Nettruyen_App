import 'package:nettruyen/app/data/repository/api_mock_config.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/domain/models/comic_list.dart';
import 'package:nettruyen/app/domain/models/content_chapter.dart';
import 'package:nettruyen/app/domain/models/genre.dart';
import 'package:nettruyen/app/domain/repository/repository_api.dart';
import 'package:nettruyen/core/resources/data_state.dart';

class RepositoryApiWrapper implements RepositoryApi {
  final RepositoryApi _realApi;
  final RepositoryApi _mockApi;

  RepositoryApiWrapper(this._realApi, this._mockApi);

  @override
  Future<DataState<List<ChapterEntity>>> getChapterByComicId(
      {required String comicId}) {
    if (ApiMockConfig.getChapterByComicId) {
      return _mockApi.getChapterByComicId(comicId: comicId);
    }
    return _realApi.getChapterByComicId(comicId: comicId);
  }

  @override
  Future<DataState<ComicListEntity>> getComicByGenre(
      {String? genreId, int? page, String? status}) {
    if (ApiMockConfig.getComicByGenre) {
      return _mockApi.getComicByGenre(
          genreId: genreId, page: page, status: status);
    }
    return _realApi.getComicByGenre(
        genreId: genreId, page: page, status: status);
  }

  @override
  Future<DataState<ComicEntity>> getComicById({required String comicId}) {
    if (ApiMockConfig.getComicById) {
      return _mockApi.getComicById(comicId: comicId);
    }
    return _realApi.getComicById(comicId: comicId);
  }

  @override
  Future<DataState<List<ComicEntity>>> getComicsSearchSuggest(
      {required String query}) {
    if (ApiMockConfig.getComicsSearchSuggest) {
      return _mockApi.getComicsSearchSuggest(query: query);
    }
    return _realApi.getComicsSearchSuggest(query: query);
  }

  @override
  Future<DataState<ComicListEntity>> getComicsSearch(
      {required String query, int? page}) {
    if (ApiMockConfig.getComicsSearch) {
      return _mockApi.getComicsSearch(query: query, page: page);
    }
    return _realApi.getComicsSearch(query: query, page: page);
  }

  @override
  Future<DataState<ComicListEntity>> getCompletedComics({int? page}) {
    if (ApiMockConfig.getCompletedComics) {
      return _mockApi.getCompletedComics(page: page);
    }
    return _realApi.getCompletedComics(page: page);
  }

  @override
  Future<DataState<ContentChapterEntity>> getContentOneChapter(
      {required String comicId, required String chapterId}) {
    if (ApiMockConfig.getContentOneChapter) {
      return _mockApi.getContentOneChapter(
          comicId: comicId, chapterId: chapterId);
    }
    return _realApi.getContentOneChapter(
        comicId: comicId, chapterId: chapterId);
  }

  @override
  Future<DataState<List<GenreEntity>>> getGenres() {
    if (ApiMockConfig.getGenres) {
      return _mockApi.getGenres();
    }
    return _realApi.getGenres();
  }

  @override
  Future<DataState<ComicListEntity>> getNewComics({int? page, String? status}) {
    if (ApiMockConfig.getNewComics) {
      return _mockApi.getNewComics(page: page, status: status);
    }
    return _realApi.getNewComics(page: page, status: status);
  }

  @override
  Future<DataState<ComicListEntity>> getRecentUpdateComics(
      {int? page, String? status}) {
    if (ApiMockConfig.getRecentUpdateComics) {
      return _mockApi.getRecentUpdateComics(page: page, status: status);
    }
    return _realApi.getRecentUpdateComics(page: page, status: status);
  }

  @override
  Future<DataState<List<ComicEntity>>> getRecommendComics() {
    if (ApiMockConfig.getRecommendComics) {
      return _mockApi.getRecommendComics();
    }
    return _realApi.getRecommendComics();
  }

  @override
  Future<DataState<ComicListEntity>> getTopComics(
      {String? topType, int? page, String? status}) {
    if (ApiMockConfig.getTopComics) {
      return _mockApi.getTopComics(
          topType: topType, page: page, status: status);
    }
    return _realApi.getTopComics(topType: topType, page: page, status: status);
  }

  @override
  Future<DataState<ComicListEntity>> getTrendingComics({int? page}) {
    if (ApiMockConfig.getTrendingComics) {
      return _mockApi.getTrendingComics(page: page);
    }
    return _realApi.getTrendingComics(page: page);
  }

  @override
  Future<DataState<ComicListEntity>> getBoyOrGirlComics(
      {required bool isBoy, int? page}) {
    if (ApiMockConfig.getBoyOrGirlComics) {
      return _mockApi.getBoyOrGirlComics(isBoy: isBoy, page: page);
    }
    return _realApi.getBoyOrGirlComics(isBoy: isBoy, page: page);
  }
}
