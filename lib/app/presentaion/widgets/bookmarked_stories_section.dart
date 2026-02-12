import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/data/services/bookmark_service.dart';
import 'package:minh_nguyet_truyen/app/domain/models/bookmarked_story.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/image_custome/image_custome.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/api.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/setup.dart';

class BookmarkedStoriesSection extends StatefulWidget {
  const BookmarkedStoriesSection({super.key});

  @override
  State<BookmarkedStoriesSection> createState() =>
      _BookmarkedStoriesSectionState();
}

class _BookmarkedStoriesSectionState extends State<BookmarkedStoriesSection> {
  final _bookmarkService = sl<BookmarkService>();
  List<BookmarkedStory> _bookmarkedStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);

    try {
      final bookmarks = await _bookmarkService.getBookmarks();
      if (mounted) {
        setState(() {
          _bookmarkedStories = bookmarks.take(5).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${difference.inDays ~/ 7} tuần trước';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_bookmarkedStories.isEmpty) {
      return const SizedBox.shrink(); // Ẩn nếu chưa bookmark truyện nào
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.bookmark,
                  color: AppColors.secondary,
                  size: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'Truyện đã lưu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Horizontal List
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _bookmarkedStories.length,
              itemBuilder: (context, index) {
                return _buildBookmarkCard(_bookmarkedStories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(BookmarkedStory story) {
    final hasThumb = story.coverUrl.isNotEmpty;
    final thumbUrl = hasThumb
        ? "$kBaseURL/images?src=${Uri.encodeComponent(story.coverUrl)}"
        : "";

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to comic detail
            Navigator.pushNamed(
              context,
              '${RoutesName.kComics}/${story.id}',
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        width: 140,
                        height: 180,
                        color: AppColors.textSecondary.withOpacity(0.1),
                        child: ImageCustome(
                          url: thumbUrl,
                        )),
                  ),

                  // Badge bookmark
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Time ago overlay
                  if (story.lastReadAt != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Text(
                          'Lưu ${_getTimeAgo(story.bookmarkedAt)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                story.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
