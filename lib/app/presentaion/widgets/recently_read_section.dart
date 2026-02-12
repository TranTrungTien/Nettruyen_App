import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/data/services/reading_progress_service.dart';
import 'package:minh_nguyet_truyen/app/domain/models/reading_progress.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/setup.dart';

class RecentlyReadSection extends StatefulWidget {
  const RecentlyReadSection({super.key});

  @override
  State<RecentlyReadSection> createState() => _RecentlyReadSectionState();
}

class _RecentlyReadSectionState extends State<RecentlyReadSection> {
  final _progressService = sl<ReadingProgressService>();
  List<ReadingProgress> _recentStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentStories();
  }

  Future<void> _loadRecentStories() async {
    setState(() => _isLoading = true);

    try {
      final recent = await _progressService.getRecentlyRead(limit: 1);
      if (mounted) {
        setState(() {
          _recentStories = recent;
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
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_recentStories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: AppColors.primary,
                  size: 30,
                ),
                SizedBox(width: 8),
                Text(
                  'Đọc gần đây',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRecentStoryCard(_recentStories.first),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentStoryCard(ReadingProgress story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(
              context,
              '${RoutesName.kComics}/${story.storyId}',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Story title
                      Text(
                        story.storyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Chapter name
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Đọc tiếp',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              story.chapter.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Time ago
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getTimeAgo(story.lastReadAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
