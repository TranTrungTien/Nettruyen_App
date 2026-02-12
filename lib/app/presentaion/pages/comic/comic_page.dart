import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/data/services/bookmark_service.dart';
import 'package:minh_nguyet_truyen/app/domain/models/bookmarked_story.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/blocs/comic_id_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:minh_nguyet_truyen/app/presentaion/pages/comic/body.dart';
import 'package:minh_nguyet_truyen/app/presentaion/pages/comic/heading.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/error_view.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/loading_widget.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/core/utils/noti.dart';
import 'package:minh_nguyet_truyen/setup.dart';

class ComicPage extends StatefulWidget {
  const ComicPage({super.key, required this.comicId});
  final String comicId;

  @override
  State<ComicPage> createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {
  final _bookmarkService = sl<BookmarkService>();
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ComicByIdBloc>()
        .add(GetComicByIdEvent(comicId: widget.comicId));
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await _bookmarkService.isBookmarked(widget.comicId);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark(ComicEntity comic) async {
    if (_isBookmarked) {
      // Xóa bookmark
      final success = await _bookmarkService.removeBookmark(comic.id ?? '');
      if (success && mounted) {
        setState(() {
          _isBookmarked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa khỏi bookmark'),
            backgroundColor: AppColors.danger,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Kiểm tra còn chỗ không
      final canAdd = await _bookmarkService.canAddMore();

      if (!canAdd) {
        // Đã đủ 20 - Hiển thị dialog
        _showBookmarkLimitDialog(comic);
        return;
      }

      // Thêm bookmark
      final story = BookmarkedStory.fromComic(comic);
      final success = await _bookmarkService.addBookmark(story);
      if (success && mounted) {
        setState(() {
          _isBookmarked = true;
        });

        final count = await _bookmarkService.getBookmarkCount();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm vào bookmark ($count/20)'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showBookmarkLimitDialog(ComicEntity comic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.secondary),
            SizedBox(width: 8),
            Text(
              'Bookmark đã đầy',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: const Text(
          'Bạn đã lưu tối đa 20 truyện. Vui lòng xóa bớt truyện cũ để thêm truyện mới.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicByIdBloc, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull && state.comic != null) {
          final comic = state.comic!;
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              title: Text(
                comic.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.primary),
              ),
              actions: [
                IconButton(
                  onPressed: () => _toggleBookmark(comic),
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color:
                        _isBookmarked ? AppColors.secondary : AppColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => showFeatureComingSoon(context),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  HeadingComic(comic: comic),
                  BodyComicPage(comic: comic),
                ],
              ),
            ),
          );
        }
        if (state is ComicFailed) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.backgroundLight,
                title: Text(state.error?.message ?? 'Đã có lỗi xảy ra'),
              ),
              body: ErrorView(
                message: state.error?.message,
                onRetry: () {
                  context
                      .read<ComicByIdBloc>()
                      .add(GetComicByIdEvent(comicId: widget.comicId));
                },
              ));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundLight,
            title: const LinearProgressIndicator(color: AppColors.primary),
          ),
          body: const LoadingWidget(),
        );
      },
    );
  }
}
