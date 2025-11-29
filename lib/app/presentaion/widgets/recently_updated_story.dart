import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/recent_update_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/genre.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';
import 'package:nettruyen/config/routes/routes_name.dart';
import 'package:nettruyen/core/constants/colors.dart';

class RecentUpdateListView extends StatelessWidget {
  const RecentUpdateListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentUpdateComicsBloc, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull) {
          final comics = state.listComic?.comics ?? [];
          if (comics.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                leading: Icon(Icons.access_time,
                    size: 30, color: AppColors.secondary),
                title: Text(
                  "Truyện mới cập nhật",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comics.length.clamp(0, 20),
                separatorBuilder: (_, __) =>
                    const Divider(height: 2, thickness: 0.5),
                itemBuilder: (context, index) {
                  final comic = comics[index];

                  Widget? genresWidget = Genres(genres: comic.genres ?? []);

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '${RoutesName.kComics}/${comic.id}/${comic.latestChapter?.id}',
                        arguments: {
                          "comic": comic,
                          "chapter": comic.latestChapter,
                          "currentChapterPage": -1,
                          "totalChapterPages": -1,
                          "isClickFirstChapter": false,
                          "isClickLastChapter": false,
                          "defaultChapters": []
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: index < 3
                                  ? Colors.orange.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: index < 3
                                    ? AppColors.danger
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comic.title ?? "Không có tiêu đề",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                genresWidget,
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "Chương: ${comic.totalChapters ?? 0} ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      comic.updatedAt ?? "Vừa cập nhật",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.textSecondary, size: 22),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          );
        }

        if (state is ComicFailed) {
          return FailedWidet(
            error: state.error!,
            onReset: () {
              context
                  .read<RecentUpdateComicsBloc>()
                  .add(GetRecentUpdateComicsEvent());
            },
          );
        }

        // Đang load
        return const LoadingWidget();
      },
    );
  }
}
