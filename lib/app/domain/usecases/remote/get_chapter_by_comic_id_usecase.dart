import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/repository/repository_api.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class GetChapterByComicIdUsecase {
  RepositoryApi repositoryApi;
  GetChapterByComicIdUsecase(this.repositoryApi);
  Future<DataState<List<ChapterEntity>>> call({required String comicId}) async {
    return await repositoryApi.getChapterByComicId(comicId: comicId);
  }
}
