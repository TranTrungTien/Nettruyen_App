import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidable/hidable.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_state.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter_per_page/chapter_per_page_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter_per_page/chapter_per_page_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter_per_page/chapter_per_page_state.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';
import 'package:nettruyen/core/constants/colors.dart';

class ChapterComicPage extends StatefulWidget {
  const ChapterComicPage({
    super.key,
    required this.comic,
    required this.chapter,
    required this.currentChapterPage,
    required this.isClickFirstChapter,
    required this.isClickLastChapter,
    required this.defaultChapters,
    required this.totalChapterPages,
  });

  final ComicEntity comic;
  final ChapterEntity chapter;
  final List<ChapterEntity> defaultChapters;
  final int currentChapterPage;
  final int totalChapterPages;
  final bool isClickFirstChapter;
  final bool isClickLastChapter;

  @override
  State<ChapterComicPage> createState() => _ChapterComicPageState();
}

class _ChapterComicPageState extends State<ChapterComicPage> {
  final _scrollController = ScrollController();

  late ChapterEntity chapter;
  List<ChapterEntity> chapters = [];
  final Map<int, List<ChapterEntity>> _pageCache = {};
  int _loadedPage = 1;
  bool _isLoadingNextPage = false;
  bool _isLoadingPrevPage = false;
  bool _hasMoreNext = true;
  bool _hasMorePrev = true;

  @override
  void initState() {
    super.initState();
    chapter = widget.chapter;
    _loadedPage = widget.currentChapterPage;
    chapters = widget.defaultChapters;
    context.read<ChapterBloc>().add(
          GetContentChapterEvent(chapterId: chapter.id, comic: widget.comic),
        );
    if (widget.isClickFirstChapter && widget.currentChapterPage > 1) {
      context.read<ChapterPerPageBloc>().add(
            GetChapterPerPageEvent(
                widget.comic.id ?? '', widget.currentChapterPage - 1),
          );
    }

    if (widget.isClickLastChapter &&
        widget.currentChapterPage < widget.totalChapterPages) {
      context.read<ChapterPerPageBloc>().add(
            GetChapterPerPageEvent(
                widget.comic.id ?? '', widget.currentChapterPage + 1),
          );
    }
    if (widget.currentChapterPage < 0) {
      _hasMorePrev = false;
      _hasMoreNext = false;
    } else if (widget.currentChapterPage == 1) {
      _hasMorePrev = false;
    } else if (widget.currentChapterPage == widget.totalChapterPages) {
      _hasMoreNext = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToChapter(ChapterEntity newChapter) {
    context.read<ChapterBloc>().add(
          GetContentChapterEvent(chapterId: newChapter.id, comic: widget.comic),
        );
    setState(() => chapter = newChapter);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _maybeLoadNextPage(int currentIndex) {
    if (!_hasMoreNext ||
        _isLoadingNextPage ||
        currentIndex == widget.totalChapterPages) {
      return;
    }

    if (currentIndex >= chapters.length - 3) {
      final nextPage = _loadedPage + 1;
      if (_pageCache.containsKey(nextPage)) {
        chapters.addAll(_pageCache[nextPage]!);
        _loadedPage = nextPage;
        setState(() {});
      } else {
        setState(() => _isLoadingNextPage = true);
        context.read<ChapterPerPageBloc>().add(
              GetChapterPerPageEvent(widget.comic.id ?? '', nextPage),
            );
      }
    }
  }

  void _maybeLoadPrevPage(int currentIndex) {
    if (!_hasMorePrev || _isLoadingPrevPage || _loadedPage <= 1) return;

    if (currentIndex <= 2) {
      final prevPage = _loadedPage - 1;
      if (_pageCache.containsKey(prevPage)) {
        chapters.insertAll(0, _pageCache[prevPage]!);
        _loadedPage = prevPage;
        setState(() {});
      } else {
        setState(() => _isLoadingPrevPage = true);
        context.read<ChapterPerPageBloc>().add(
              GetChapterPerPageEvent(widget.comic.id ?? '', prevPage),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChapterPerPageBloc, ChapterPerPageState>(
      listener: (context, state) {
        if (state is ChapterPerPageSuccessfull) {
          final page = state.page;
          final newChapters = state.chapters;
          _pageCache[page] = newChapters;
          setState(() {
            if (page > _loadedPage) {
              chapters = [...chapters, ...newChapters];
              _loadedPage = page;
              _hasMoreNext = newChapters.isNotEmpty;
            } else if (page < _loadedPage) {
              chapters = [...newChapters, ...chapters];
              _hasMorePrev = newChapters.isNotEmpty;
            } else {
              chapters = newChapters;
            }

            _isLoadingNextPage = false;
            _isLoadingPrevPage = false;
          });
        } else if (state is ChapterPerPageFailed) {
          _isLoadingNextPage = false;
          _isLoadingPrevPage = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Lỗi tải danh sách chapter: ${state.error}')),
          );
        }
      },
      child: BlocBuilder<ChapterBloc, ChapterState>(
        builder: (context, state) {
          final isLoadingChapter = state is ChapterLoading;
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: Hidable(
              controller: _scrollController,
              child: AppBar(
                backgroundColor: AppColors.backgroundLight,
                title: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    widget.comic.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    chapter.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            body: _buildBody(state),
            bottomNavigationBar: Hidable(
              controller: _scrollController,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _buildPrevAndNextButton(isLoadingChapter),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrevAndNextButton(bool isLoadingChapter) {
    final currentIndex = chapters.indexWhere((e) => e.id == chapter.id);

    void _goPrev() {
      if (currentIndex <= 0) return;

      final prevChapter = chapters[currentIndex - 1];
      _navigateToChapter(prevChapter);
      _maybeLoadPrevPage(currentIndex - 1);
    }

    void _goNext() {
      if (currentIndex >= chapters.length - 1) return;

      final nextChapter = chapters[currentIndex + 1];
      _navigateToChapter(nextChapter);
      _maybeLoadNextPage(currentIndex + 1);
    }

    final bool hasPrev = currentIndex > 0 || _hasMorePrev;
    final bool hasNext = currentIndex < chapters.length - 1 || _hasMoreNext;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
            onPressed: isLoadingChapter || !hasPrev ? null : _goPrev,
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.textOnPrimary, size: 14),
            label: const Text('Chương trước',
                style: TextStyle(color: AppColors.textOnPrimary, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
            onPressed: isLoadingChapter || !hasNext ? null : _goNext,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Chương sau',
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textOnPrimary)),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppColors.textOnPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ChapterState state) {
    if (state is ChapterSuccessfull) {
      final content = state.contentChapter?.content ?? '';
      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(content, style: const TextStyle(fontSize: 16, height: 1.8)),
            const SizedBox(height: 20),
            _buildPrevAndNextButton(false),
          ],
        ),
      );
    }
    if (state is ChapterFailed) {
      return FailedWidet(error: state.error!);
    }
    return const LoadingWidget();
  }
}
