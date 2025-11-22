import 'package:flutter/material.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/boy_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/completed_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/girl_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/recent_update_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/trending_comics_bloc.dart';
import 'package:nettruyen/app/presentaion/pages/chapter/chapter_comic_page.dart';
import 'package:nettruyen/app/presentaion/pages/comic/comic_page.dart';
import 'package:nettruyen/app/presentaion/pages/home/home_page.dart';
import 'package:nettruyen/app/presentaion/pages/page_list_comic_by_bloc.dart';
import 'package:nettruyen/app/presentaion/pages/page_not_found.dart';
import 'package:nettruyen/app/presentaion/pages/search/search_page.dart';
import 'package:nettruyen/config/routes/routes_name.dart';
import 'package:nettruyen/setup.dart';

class CustomeRoute {
  static PageRoute generate(RouteSettings settings) {
    print("route: ${settings.name}");
    print("arguments: ${settings.arguments}");

    if (settings.name != null &&
        settings.name!.startsWith(RoutesName.kComics)) {
      try {
        final uri = Uri.parse(settings.name!);
        final segments = uri.pathSegments;
        // /comics/:comicSlug
        if (segments.length == 2) {
          final comicSlug = segments[1];
          return MaterialPageRoute(
            builder: (context) => ComicPage(comicId: comicSlug),
            settings: settings,
          );
        }

        // /comics/:comicSlug/:chapterId
        if (segments.length == 3) {
          var data = settings.arguments as Map<String, dynamic>;
          ComicEntity? comic = data["comic"];
          ChapterEntity? chapter = data["chapter"];
          if (comic != null && chapter != null) {
            return MaterialPageRoute(
                builder: (context) =>
                    ChapterComicPage(comic: comic, chapter: chapter),
                settings: settings);
          }
        }
      } catch (e) {
        print("Error route: $settings, $e");
      }
    }

    // Các route còn lại
    if (settings.name == RoutesName.kHomePage) {
      return MaterialPageRoute(
          builder: (context) => const HomePage(), settings: settings);
    }
    if (settings.name == RoutesName.kPopular) {
      return MaterialPageRoute(
          builder: (context) => PageListComicByBloc(
              title: "Truyện nổi bật", bloc: sl<TrendingComicsBloc>()),
          settings: settings);
    }
    if (settings.name == RoutesName.kCompleted) {
      return MaterialPageRoute(
          builder: (context) => PageListComicByBloc(
              title: "Truyện đã hoàn thành", bloc: sl<CompletedComicBloc>()),
          settings: settings);
    }
    if (settings.name == RoutesName.kRecentUpdate) {
      return MaterialPageRoute(
          builder: (context) => PageListComicByBloc(
              title: "Truyện mới cập nhật", bloc: sl<RecentUpdateComicsBloc>()),
          settings: settings);
    }
    if (settings.name == RoutesName.kBoy) {
      return MaterialPageRoute(
          builder: (context) =>
              PageListComicByBloc(title: "Boy", bloc: sl<BoyComicBloc>()),
          settings: settings);
    }
    if (settings.name == RoutesName.kGirl) {
      return MaterialPageRoute(
          builder: (context) =>
              PageListComicByBloc(title: "Girl", bloc: sl<GirlComicBloc>()),
          settings: settings);
    }

    if (settings.name == RoutesName.kSearch) {
      return MaterialPageRoute(
          builder: (context) => const SearchPage(), settings: settings);
    }

    return MaterialPageRoute(
        builder: (context) => const PageNotFound(), settings: settings);
  }
}
