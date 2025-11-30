import 'package:minh_nguyet_truyen/app/domain/models/comic_list.dart';
import 'package:minh_nguyet_truyen/app/domain/repository/repository_api.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';

class GetTrendingComicsUsecase {
  RepositoryApi repositoryApi;
  GetTrendingComicsUsecase(this.repositoryApi);
  Future<DataState<ComicListEntity>> call({int? page}) async {
    return await repositoryApi.getTrendingComics(page: page);
  }
}
