part of 'api_nettruyen_service.dart';

class _ApiNettruyenService implements ApiNettruyenService {
  late final Dio dio;
  _ApiNettruyenService({Dio? dio}) {
    this.dio = dio ?? Dio();
  }

  @override
  Future<HttpResponse<List<ChapterEntity>>> getChaptersByPage(
      {required String id, required int page}) async {
    final result = await dio.get('$kBaseURL/story/$id/$page');
    final value = List<ChapterEntity>.from(
      (result.data as List<dynamic>).map<ChapterEntity>(
        (x) => ChapterModel.fromMap(x as Map<String, dynamic>),
      ),
    );
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<List<ChapterEntity>>> getChapterByComicId(
      {required String comicId}) async {
    final result = await dio.get("$kBaseURL/story/$comicId/chapters");
    final value = List<ChapterEntity>.from(
      (result.data as List<dynamic>).map<ChapterEntity>(
        (x) => ChapterModel.fromMap(x as Map<String, dynamic>),
      ),
    );
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicListEntity>> getComicByGenre(
      {String? genreId, int? page, String? status}) async {
    String api = "$kBaseURL/genres/";
    api += genreId ?? "all";
    api += page != null ? "?page=$page" : "?page=1";
    if (status != null) {
      api += "&status=$status";
    }
    final result = await dio.get(api);
    final value = ComicListModel.fromMap(result.data);

    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicEntity>> getComicById(
      {required String id, int? page}) async {
    String api = "$kBaseURL/story/$id";
    if (page != null) {
      api += "?page=$page";
    }
    final result = await dio.get(api);
    final value = ComicModel.fromMap(result.data);
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicListEntity>> getComicsSearch(
      {required String query, int? page}) async {
    String api = "$kBaseURL/search?q=$query";
    api += page != null ? "&page=$page" : "&page=1";
    final result = await dio.get(api);
    final value = ComicListModel.fromMap(result.data);
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicListEntity>> getCompletedComics({int? page}) async {
    String api = "$kBaseURL/completed-story";
    api += page != null ? "?page=$page" : "?page=1";

    final result = await dio.get(api);
    final value = ComicListModel.fromMap(result.data);
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ContentChapterEntity>> getContentOneChapter(
      {required String comicId, required String chapterId}) async {
    final result =
        await dio.get("$kBaseURL/story/$comicId/chapters/$chapterId");
    final value = ContentChapterModel.fromMap(result.data);
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<List<GenreEntity>>> getGenres() async {
    final result = await dio.get("$kBaseURL/genres");
    List<GenreEntity> value = [];
    for (var element in result.data) {
      value.add(GenreModel.fromMap(element));
    }
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicListEntity>> getRecentUpdateComics(
      {int? page, String? status}) async {
    String api = "$kBaseURL/recent-update-story";
    api += page != null ? "?page=$page" : "?page=1";
    if (status != null) {
      api += "&status=$status";
    }

    final result = await dio.get(api);
    final value = ComicListModel.fromMap(result.data);
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<List<ComicEntity>>> getRecommendComics() async {
    final result = await dio.get("$kBaseURL/recommend-story");
    List<ComicEntity> value = [];
    for (var element in result.data['comics']) {
      value.add(ComicModel.fromMap(element));
    }
    return HttpResponse(value, result);
  }

  @override
  Future<HttpResponse<ComicListEntity>> getTrendingComics({int? page}) async {
    String api = "$kBaseURL/trending-story";
    api += page != null ? "?page=$page" : "?page=1";
    final result = await dio.get(api);
    final value = ComicListModel.fromMap(result.data);
    return HttpResponse(value, result);
  }
}
