
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/domain/models/comic_list.dart';
import 'package:nettruyen/app/domain/models/content_chapter.dart';
import 'package:nettruyen/app/domain/models/genre.dart';
import 'package:nettruyen/app/domain/models/image_chapter.dart';
import 'package:nettruyen/app/domain/repository/repository_api.dart';
import 'package:nettruyen/core/resources/data_state.dart';

class RepositoryApiMock implements RepositoryApi {
  @override
  Future<DataState<List<ChapterEntity>>> getChapterByComicId(
      {required String comicId}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ChapterEntity> chapters = [
      ChapterEntity(id: 1, name: "Chapter 1"),
      ChapterEntity(id: 2, name: "Chapter 2"),
      ChapterEntity(id: 3, name: "Chapter 3"),
    ];
    return DataSuccess(chapters);
  }

  @override
  Future<DataState<ComicListEntity>> getComicByGenre(
      {String? genreId, int? page, String? status}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "1",
          title: "Comic By Genre 1",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "2",
          title: "Comic By Genre 2",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ComicEntity>> getComicById({required String comicId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return DataSuccess(ComicEntity(
        id: comicId,
        title: "Detailed Comic",
        thumbnail: "https://via.placeholder.com/150",
        description: "This is a detailed description of the comic.",
        authors: "Author Name",
        status: "Ongoing",
        genres: [GenreEntity(id: "1", name: "Action")],
        chapters: [ChapterEntity(id: 1, name: "Chapter 1")]));
  }

  @override
  Future<DataState<List<ComicEntity>>> getComicsSearchSuggest(
      {required String query}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "s1",
          title: "Suggestion 1 for $query",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "s2",
          title: "Suggestion 2 for $query",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(comics);
  }

  @override
  Future<DataState<ComicListEntity>> getComicsSearch(
      {required String query, int? page}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "search1",
          title: "Search Result 1",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "search2",
          title: "Search Result 2",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ComicListEntity>> getCompletedComics({int? page}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "completed1",
          title: "Completed Comic 1",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "completed2",
          title: "Completed Comic 2",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ContentChapterEntity>> getContentOneChapter(
      {required String comicId, required int chapterId}) async {
    await Future.delayed(const Duration(seconds: 1));
    final content = ContentChapterEntity(
      images: [
        ImageChapterEntity(page: 1, src: "https://via.placeholder.com/800x1200"),
        ImageChapterEntity(page: 2, src: "https://via.placeholder.com/800x1200"),
        ImageChapterEntity(page: 3, src: "https://via.placeholder.com/800x1200"),
      ],
    );
    return DataSuccess(content);
  }

  @override
  Future<DataState<List<GenreEntity>>> getGenres() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<GenreEntity> genres = [
      GenreEntity(id: "1", name: "Action"),
      GenreEntity(id: "2", name: "Adventure"),
      GenreEntity(id: "3", name: "Comedy"),
      GenreEntity(id: "4", name: "Drama"),
      GenreEntity(id: "5", name: "Fantasy"),
      GenreEntity(id: "6", name: "Horror"),
      GenreEntity(id: "7", name: "Isekai"),
      GenreEntity(id: "8", name: "Manhwa"),
      GenreEntity(id: "9", name: "Romance"),
      GenreEntity(id: "10", name: "Sci-fi"),
    ];
    return DataSuccess(genres);
  }

  @override
  Future<DataState<ComicListEntity>> getNewComics(
      {int? page, String? status}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "new1",
          title: "New Comic 1",
          thumbnail: "https://via.placeholder.com/150",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 1')]),
      ComicEntity(
          id: "new2",
          title: "New Comic 2",
          thumbnail: "https://via.placeholder.com/150",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 1')]),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ComicListEntity>> getRecentUpdateComics(
      {int? page, String? status}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "recent1",
          title: "Recently Updated 1",
          thumbnail: "https://via.placeholder.com/150",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 10 (New)')]),
      ComicEntity(
          id: "recent2",
          title: "Recently Updated 2",
          thumbnail: "https://via.placeholder.com/150",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 5 (New)')]),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<List<ComicEntity>>> getRecommendComics() async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "rec1",
          title: "Recommended Comic 1",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "rec2",
          title: "Recommended Comic 2",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "rec3",
          title: "Recommended Comic 3",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(comics);
  }

  @override
  Future<DataState<ComicListEntity>> getTopComics(
      {String? topType, int? page, String? status}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "top1",
          title: "Top Comic 1 - $topType",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: "top2",
          title: "Top Comic 2 - $topType",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ComicListEntity>> getTrendingComics({int? page}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: "trending1",
          title: "Trending Comic 1",
          thumbnail: "https://i.pinimg.com/736x/c9/2c/a3/c92ca3e49e0c129202112d8a94b5c7f2.jpg",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 10')]),
      ComicEntity(
          id: "trending2",
          title: "Trending Comic 2",
          thumbnail: "https://i.pinimg.com/736x/f0/6a/b8/f06ab821b06822557a553f19154a3233.jpg",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 25')]),
      ComicEntity(
          id: "trending3",
          title: "Trending Comic 3",
          thumbnail: "https://i.pinimg.com/originals/91/9f/e4/919fe4b494d456455a5362e847c1b8f5.jpg",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 1')]),
      ComicEntity(
          id: "trending4",
          title: "Trending Comic 4",
          thumbnail: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 12')]),
      ComicEntity(
          id: "trending5",
          title: "Trending Comic 5",
          thumbnail: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
          chapters: [ChapterEntity(id: 1, name: 'Chapter 112')]),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }

  @override
  Future<DataState<ComicListEntity>> getBoyOrGirlComics(
      {required bool isBoy, int? page}) async {
    await Future.delayed(const Duration(seconds: 1));
    final List<ComicEntity> comics = [
      ComicEntity(
          id: isBoy ? "boy1" : "girl1",
          title: isBoy ? "Boy Comic 1" : "Girl Comic 1",
          thumbnail: "https://via.placeholder.com/150"),
      ComicEntity(
          id: isBoy ? "boy2" : "girl2",
          title: isBoy ? "Boy Comic 2" : "Girl Comic 2",
          thumbnail: "https://via.placeholder.com/150"),
    ];
    return DataSuccess(ComicListEntity(comics: comics));
  }
}
