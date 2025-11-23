import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/completed_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/recent_update_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/recommend_comics_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/trending_comics_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/comic/item_comic_1.dart';
import 'package:nettruyen/app/presentaion/widgets/grid_view_comics.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/not_found_icon.dart';
import 'package:nettruyen/config/routes/routes_name.dart';
import 'package:nettruyen/core/constants/colors.dart';
import 'package:nettruyen/core/constants/constants.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({super.key});

  // Data loading function can remain static or be integrated into the State
  static void loadingData(BuildContext context) {
    context.read<RecommendComicsBloc>().add(GetRecommendComicsEvent());
    context.read<TrendingComicsBloc>().add(GetTrendingComicsEvent());
    context.read<CompletedComicBloc>().add(GetCompletedComicsEvent());
    context.read<RecentUpdateComicsBloc>().add(GetRecentUpdateComicsEvent());
  }

  @override
  State<BodyHomePage> createState() => _BodyHomePageState();
}

class _BodyHomePageState extends State<BodyHomePage> {
  @override
  void initState() {
    super.initState();
    // Trigger data loading when the widget initializes
    BodyHomePage.loadingData(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          // 1. Recommended Comics (Horizontal List - Unique Layout)
          _buildRecommendComics(context),

          // 2. Trending Comics (Grid View - Reusable Component)
          _ComicCategory<TrendingComicsBloc>(
            title: "Truyện nổi bật",
            icon: Icons.local_fire_department_outlined,
            iconColor: AppColors.danger,
            route: RoutesName.kPopular,
            refreshEvent: GetTrendingComicsEvent(),
            titleColor: AppColors.primary,
          ),

          // 3. Recent Update Comics (Grid View - Reusable Component)
          _ComicCategory<RecentUpdateComicsBloc>(
            title: "Truyện mới cập nhật",
            icon: Icons.access_time,
            iconColor: AppColors.secondary.withOpacity(0.7),
            route: RoutesName.kRecentUpdate,
            refreshEvent: GetRecentUpdateComicsEvent(),
            titleColor: AppColors.primary,
          ),

          // 4. Completed Comics (Grid View - Reusable Component)
          _ComicCategory<CompletedComicBloc>(
            title: "Truyện đã hoàn thành",
            icon: Icons.verified,
            iconColor: AppColors.success, // Added a color for consistency
            route: RoutesName.kCompleted,
            refreshEvent: GetCompletedComicsEvent(),
            titleColor: AppColors.primary,
          ),

          //Footer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    style:
                        TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: APP_NAME,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' – nơi đọc truyện online miễn phí với kho truyện tiên hiệp, đô thị, dị giới, sắc hiệp được cập nhật nhanh, giao diện tối ưu cho trải nghiệm đọc mượt mà.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "©2025. Nội dung được tổng hợp từ các nguồn bên thứ ba. Tôi không sở hữu bản quyền và không chịu trách nhiệm về tính chính xác của nội dung",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget for the unique Recommend Comics section (horizontal list)
  Widget _buildRecommendComics(BuildContext context) {
    return BlocBuilder<RecommendComicsBloc, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull) {
          final listComic = state.listComic?.comics;

          if (listComic == null || listComic.isEmpty) {
            return const NotFoundIcon();
          }

          return Column(
            children: [
              const ListTile(
                contentPadding: EdgeInsets.only(left: 10),
                leading: Icon(
                  Icons.local_fire_department,
                  size: 30,
                  color: AppColors.secondary,
                ),
                title: Text(
                  "Truyện Hot",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                height: 160,
                margin: const EdgeInsets.only(bottom: 20),
                child: ListView.builder(
                  itemCount: listComic.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ItemComic1(comic: listComic[index]);
                  },
                ),
              ),
            ],
          );
        }
        if (state is ComicFailed) {
          return FailedWidet(
            error: state.error!,
            onReset: () {
              context
                  .read<RecommendComicsBloc>()
                  .add(GetRecommendComicsEvent());
            },
          );
        }
        return const LoadingWidget();
      },
    );
  }
}

// 🎯 Reusable Widget for GridViewComics categories
class _ComicCategory<B extends Bloc<ComicEvent, ComicState>>
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color titleColor;
  final String route;
  final ComicEvent refreshEvent;
  static const int maxItems = 20;
  final int crossAxisCount = 2;

  const _ComicCategory(
      {required this.title,
      required this.icon,
      required this.iconColor,
      required this.route,
      required this.refreshEvent,
      required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull) {
          final comicList = state.listComic?.comics;
          var length = comicList?.length ?? 0;

          final itemCount = length > maxItems ? maxItems : length;

          return GridViewComics(
            itemCount: itemCount,
            listValue: comicList,
            icon: icon,
            iconColor: iconColor,
            titleColor: titleColor,
            crossAxisCount: crossAxisCount,
            onPressedShowAll: () {
              Navigator.pushNamed(context, route);
            },
            title: title,
          );
        }

        if (state is ComicFailed) {
          return FailedWidet(
            error: state.error!,
            onReset: () {
              context.read<B>().add(refreshEvent);
            },
          );
        }

        return const LoadingWidget();
      },
    );
  }
}
