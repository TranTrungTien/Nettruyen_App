import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/repository/repository_api.dart';
import 'package:nettruyen/core/resources/data_state.dart';

class GetChapterPerPageUsecase {
  RepositoryApi repositoryApi;
  GetChapterPerPageUsecase(this.repositoryApi);
  Future<DataState<List<ChapterEntity>>> call(
      {required String id, required int page}) async {
    return await repositoryApi.getChaptersByPage(id: id, page: page);
  }
}
