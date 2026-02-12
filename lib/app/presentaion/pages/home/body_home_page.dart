import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/blocs/completed_comic_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/blocs/recent_update_comic_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/blocs/recommend_comics_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/blocs/trending_comics_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/bookmarked_stories_section.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/comic/item_comic_1.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/footer.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/recently_read_section.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/reload.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/story_grid.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/loading_widget.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/not_found_icon.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/recently_updated_story.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({super.key});
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
    BodyHomePage.loadingData(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          _buildRecommendStory(context),
          const RecentlyReadSection(),
          const BookmarkedStoriesSection(),
          const RecentUpdateListView(),
          _ComicCategory<CompletedComicBloc>(
            title: "Truyện đã hoàn thành",
            icon: Icons.verified,
            iconColor: AppColors.success,
            route: RoutesName.kCompleted,
            refreshEvent: GetCompletedComicsEvent(),
            titleColor: AppColors.primary,
          ),

          //Footer
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildRecommendStory(BuildContext context) {
    return BlocBuilder<RecommendComicsBloc, ComicState>(
        builder: (context, state) {
      Widget? buildList() {
        if (state is ComicSuccesfull) {
          final listComic = state.listComic?.comics;
          if (listComic == null || listComic.isEmpty) {
            return const NotFoundIcon();
          } else {
            return ListView.separated(
              itemCount: listComic.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                return ItemComic1(comic: listComic[index]);
              },
            );
          }
        } else if (state is ComicFailed) {
          return Reload(
            onRetry: () {
              context
                  .read<RecommendComicsBloc>()
                  .add(GetRecommendComicsEvent());
            },
          );
        } else {
          return const LoadingWidget();
        }
      }

      return Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.only(left: 10),
            leading: Icon(
              Icons.local_fire_department,
              size: 30,
              color: AppColors.danger,
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
            child: buildList(),
          ),
        ],
      );
    });
  }
}

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
        final stories = state.listComic?.comics;
        final length = stories?.length ?? 0;
        final itemCount = length > maxItems ? maxItems : length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 10),
              leading: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
              trailing: TextButton(
                onPressed: () => Navigator.pushNamed(context, route),
                child: const Icon(Icons.chevron_right,
                    size: 30, color: AppColors.primary),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
            if (state is ComicFailed)
              Reload(
                onRetry: () => context.read<B>().add(refreshEvent),
              )
            else if (state is ComicLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: LoadingWidget()),
              )
            else if (stories == null || stories.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: NotFoundIcon(),
              )
            else
              StoryGrid(
                stories: stories,
                itemCount: itemCount,
                crossAxisCount: 2,
              ),
          ],
        );
      },
    );
  }
}
