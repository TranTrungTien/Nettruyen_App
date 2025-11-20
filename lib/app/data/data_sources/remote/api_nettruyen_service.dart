import 'package:dio/dio.dart';
import 'package:nettruyen/app/data/models/chapter.dart';
import 'package:nettruyen/app/data/models/comic.dart';
import 'package:nettruyen/app/data/models/comic_list.dart';
import 'package:nettruyen/app/data/models/content_chapter.dart';
import 'package:nettruyen/app/data/models/genre.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/domain/models/comic_list.dart';
import 'package:nettruyen/app/domain/models/content_chapter.dart';
import 'package:nettruyen/app/domain/models/genre.dart';
import 'package:nettruyen/core/constants/api.dart';
import 'package:nettruyen/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';

part 'api_nettruyen_service.g.dart';

abstract class ApiNettruyenService {
  factory ApiNettruyenService({Dio? dio}) => _ApiNettruyenService(dio: dio);

  Future<HttpResponse<List<GenreEntity>>> getGenres();

  Future<HttpResponse<ComicListEntity>> getComicByGenre(
      {String? genreId, int? page, String? status});

  Future<HttpResponse<ComicListEntity>> getTrendingComics({int? page});

  Future<HttpResponse<ComicListEntity>> getComicsSearch(
      {required String query, int? page});

  Future<HttpResponse<List<ComicEntity>>> getComicsSearchSuggest(
      {required String query});

  Future<HttpResponse<List<ComicEntity>>> getRecommendComics();

  Future<HttpResponse<ComicListEntity>> getNewComics(
      {int? page, String? status});

  Future<HttpResponse<ComicListEntity>> getRecentUpdateComics(
      {int? page, String? status});

  Future<HttpResponse<ComicListEntity>> getBoyOrGirlComics(
      {required bool isBoy, int? page});

  Future<HttpResponse<ComicListEntity>> getCompletedComics({int? page});

  Future<HttpResponse<ComicEntity>> getComicById(
      {required String id, int? page});

  Future<HttpResponse<List<ChapterEntity>>> getChapterByComicId(
      {required String comicId});

  Future<HttpResponse<List<ChapterEntity>>> getChaptersByPage(
      {required String id, required int page});

  Future<HttpResponse<ContentChapterEntity>> getContentOneChapter(
      {required String comicId, required String chapterId});

  Future<HttpResponse<ComicListEntity>> getTopComics(
      {String? topType, int? page, String? status});
}
