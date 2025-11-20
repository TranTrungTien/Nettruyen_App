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
          // _buildRecommendComics(context),

          // 2. Trending Comics (Grid View - Reusable Component)
          // _ComicCategory<TrendingComicsBloc>(
          //   title: "Truyện nổi bật",
          //   icon: Icons.local_fire_department_outlined,
          //   iconColor: Colors.red,
          //   route: RoutesName.kPopular,
          //   refreshEvent: GetTrendingComicsEvent(),
          // ),

          // // // 3. Recent Update Comics (Grid View - Reusable Component)
          // _ComicCategory<RecentUpdateComicsBloc>(
          //   title: "Truyện mới cập nhật",
          //   icon: Icons.access_time,
          //   iconColor: const Color.fromARGB(255, 255, 200, 0),
          //   route: RoutesName.kRecentUpdate,
          //   refreshEvent: GetRecentUpdateComicsEvent(),
          // ),

          // // // 4. Completed Comics (Grid View - Reusable Component)
          // _ComicCategory<CompletedComicBloc>(
          //   title: "Truyện đã hoàn thành",
          //   icon: Icons.verified,
          //   iconColor: Colors.green, // Added a color for consistency
          //   route: RoutesName.kCompleted,
          //   refreshEvent: GetCompletedComicsEvent(),
          // ),
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

          // **Logic check for comicLength == 0**
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
                  color: Color.fromARGB(255, 253, 133, 4),
                ),
                title: Text(
                  "Truyện Hot",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  final String route;
  final ComicEvent refreshEvent;
  static const int maxItems = 20; // Define max items here

  const _ComicCategory({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.route,
    required this.refreshEvent,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull) {
          final comicList = state.listComic?.comics;
          var length = comicList?.length ?? 0;

          // Determine itemCount, capping at maxItems
          final itemCount = length > maxItems ? maxItems : length;

          return GridViewComics(
            itemCount: itemCount,
            listValue: comicList,
            icon: icon,
            iconColor: iconColor,
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
