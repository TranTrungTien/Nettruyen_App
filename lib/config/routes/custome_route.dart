import 'package:flutter/material.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/completed_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/recent_update_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/trending_comics_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:nettruyen/app/presentaion/pages/chapter/chapter_comic_page.dart';
import 'package:nettruyen/app/presentaion/pages/comic/comic_page.dart';
import 'package:nettruyen/app/presentaion/pages/home/home_page.dart';
import 'package:nettruyen/app/presentaion/pages/page_not_found.dart';
import 'package:nettruyen/app/presentaion/pages/search/search_page.dart';
import 'package:nettruyen/config/routes/routes_name.dart';
import 'package:nettruyen/config/routes/type_route.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    final name = settings.name ?? '';
    debugPrint('route: $name, args: ${settings.arguments}');

    // Path-based: /comics/:slug or /comics/:slug/:chapterId
    if (name.startsWith(RoutesName.kComics)) {
      try {
        final uri = Uri.parse(name);
        final seg = uri.pathSegments;
        if (seg.length == 2) {
          final slug = seg[1];
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ComicPage(comicId: slug),
          );
        }
        if (seg.length == 3) {
          final args = (settings.arguments ?? {}) as Map<String, dynamic>;
          final ComicEntity? comic = args['comic'] as ComicEntity?;
          final ChapterEntity? chapter = args['chapter'] as ChapterEntity?;
          final List<ChapterEntity> defaultChapters =
              (args['defaultChapters'] as List<dynamic>? ?? [])
                  .map((e) => e as ChapterEntity)
                  .toList();
          final int currentChapterPage =
              args['currentChapterPage'] as int? ?? 1;
          final int totalChapterPages = args['totalChapterPages'] as int? ?? 1;
          final bool isClickFirstChapter =
              args['isClickFirstChapter'] as bool? ?? true;
          final bool isClickLastChapter =
              args['isClickLastChapter'] as bool? ?? false;

          if (comic != null && chapter != null) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ChapterComicPage(
                comic: comic,
                chapter: chapter,
                currentChapterPage: currentChapterPage,
                totalChapterPages: totalChapterPages,
                isClickFirstChapter: isClickFirstChapter,
                isClickLastChapter: isClickLastChapter,
                defaultChapters: defaultChapters,
              ),
            );
          }
        }
      } catch (_) {
        // fall through to not found
      }
    }

    // Named routes typed
    switch (name) {
      case RoutesName.kHomePage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );

      case RoutesName.kPopular:
        return typedListRoute<TrendingComicsBloc>(
          settings: settings,
          title: 'Truyện nổi bật',
          makeEvent: (p) => GetTrendingComicsEvent(page: p),
        );

      case RoutesName.kCompleted:
        return typedListRoute<CompletedComicBloc>(
          settings: settings,
          title: 'Truyện đã hoàn thành',
          makeEvent: (p) => GetCompletedComicsEvent(page: p),
        );

      case RoutesName.kRecentUpdate:
        return typedListRoute<RecentUpdateComicsBloc>(
          settings: settings,
          title: 'Truyện mới cập nhật',
          makeEvent: (p) => GetRecentUpdateComicsEvent(page: p),
        );

      case RoutesName.kSearch:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SearchPage(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PageNotFound(),
        );
    }
  }
}
