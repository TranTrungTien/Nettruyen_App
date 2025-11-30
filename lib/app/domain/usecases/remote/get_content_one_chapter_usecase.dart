import 'package:minh_nguyet_truyen/app/domain/models/content_chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/repository/repository_api.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class GetContentOneChapterUsecase {
  RepositoryApi repositoryApi;
  GetContentOneChapterUsecase(this.repositoryApi);
  Future<DataState<ContentChapterEntity>> call(
      {required String comicId, required String chapterId}) async {
    return await repositoryApi.getContentOneChapter(
        comicId: comicId, chapterId: chapterId);
  }
}
