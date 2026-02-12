import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/data/services/bookmark_service.dart';
import 'package:minh_nguyet_truyen/app/domain/models/bookmarked_story.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/api.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/core/constants/string.dart';
import 'package:minh_nguyet_truyen/setup.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/image_custome/image_custome.dart';

enum SortOption {
  newest('Mới nhất'),
  oldest('Cũ nhất'),
  nameAZ('Tên A-Z'),
  nameZA('Tên Z-A');

  final String label;
  const SortOption(this.label);
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SortOption _currentSort = SortOption.newest;

  final _bookmarkService = sl<BookmarkService>();
  List<BookmarkedStory> _allStories = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      final bookmarks = await _bookmarkService.getBookmarks();
      if (mounted) {
        setState(() {
          _allStories = bookmarks;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải bookmark: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

// Cập nhật _removeBookmark
  void _removeBookmark(BookmarkedStory story) async {
    final success = await _bookmarkService.removeBookmark(story.id);
    if (success && mounted) {
      setState(() {
        _allStories.removeWhere((s) => s.id == story.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa "${story.title}" khỏi bookmark'),
          backgroundColor: AppColors.danger,
          action: SnackBarAction(
            label: 'Hoàn tác',
            textColor: Colors.white,
            onPressed: () async {
              await _bookmarkService.addBookmark(story);
              _loadBookmarks();
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  List<BookmarkedStory> get _filteredStories {
    var stories = _allStories.where((story) {
      if (_searchQuery.isEmpty) return true;

      // Normalize cả query và title để search không dấu
      final normalizedQuery = removeDiacritics(_searchQuery.toLowerCase());
      final normalizedTitle = removeDiacritics(story.title.toLowerCase());
      final normalizedAuthor = removeDiacritics(story.author.toLowerCase());

      return normalizedTitle.contains(normalizedQuery) ||
          normalizedAuthor.contains(normalizedQuery);
    }).toList();

    // Sắp xếp
    switch (_currentSort) {
      case SortOption.newest:
        stories.sort((a, b) => b.bookmarkedAt.compareTo(a.bookmarkedAt));
        break;
      case SortOption.oldest:
        stories.sort((a, b) => a.bookmarkedAt.compareTo(b.bookmarkedAt));
        break;
      case SortOption.nameAZ:
        stories.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.nameZA:
        stories.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return stories;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Sắp xếp theo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ...SortOption.values.map((option) {
                return RadioListTile<SortOption>(
                  title: Text(
                    option.label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: _currentSort == option
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  value: option,
                  groupValue: _currentSort,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _currentSort = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading khi đang tải
    if (_isLoadingData) {
      return Container(
        color: AppColors.backgroundLight,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Container(
      color: AppColors.backgroundLight,
      child: _filteredStories.isEmpty &&
              _searchQuery.isEmpty &&
              _allStories.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Header thống kê
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        icon: Icons.bookmark,
                        label: 'Tổng số',
                        value: '${_allStories.length}',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      _buildStatCard(
                        icon: Icons.auto_stories,
                        label: 'Đang đọc',
                        value: '${_allStories.length}',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      _buildStatCard(
                        icon: Icons.check_circle,
                        label: 'Hoàn thành',
                        value: '0',
                      ),
                    ],
                  ),
                ),

                // Thanh tìm kiếm và sắp xếp
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: AppColors.textSecondary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm truyện...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.6),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.textSecondary.withOpacity(0.6),
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _searchQuery = '';
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.sort,
                            color: AppColors.textOnPrimary,
                            size: 20,
                          ),
                          onPressed: _showSortOptions,
                        ),
                      ),
                    ],
                  ),
                ),

                // Danh sách truyện
                Expanded(
                  child: _filteredStories.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredStories.length,
                          itemBuilder: (context, index) {
                            return _buildStoryCard(_filteredStories[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(BookmarkedStory story) {
    final hasThumb = story.coverUrl.isNotEmpty;
    final thumbUrl = hasThumb
        ? "$kBaseURL/images?src=${Uri.encodeComponent(story.coverUrl)}"
        : "";

    return Dismissible(
      key: Key(story.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Xóa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.backgroundLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Xác nhận xóa',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: Text(
              'Bạn có chắc muốn xóa "${story.title}" khỏi danh sách bookmark?',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Hủy',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Xóa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        _removeBookmark(story);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Navigate to story detail
              Navigator.pushNamed(context, '${RoutesName.kComics}/${story.id}',
                  arguments: story.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh bìa
                  ImageCustome2(
                    url: thumbUrl,
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 120,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(width: 8),
                  // Thông tin truyện
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề
                        Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Thể loại
                        if (story.genres.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: story.genres.take(2).map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 8),
                        // Tác giả
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                story.author.isNotEmpty
                                    ? story.author
                                    : 'Đang cập nhật',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Mô tả
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              story.description.isNotEmpty
                                  ? story.description
                                  : 'Đang cập nhật',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Nút xóa
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: AppColors.textSecondary,
                    iconSize: 20,
                    onPressed: () {
                      _showStoryOptions(story);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showStoryOptions(BookmarkedStory story) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book, color: AppColors.primary),
                title: const Text('Đọc tiếp'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, '${RoutesName.kComics}/${story.id}',
                      arguments: story.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.secondary),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.danger),
                title: const Text(
                  'Xóa khỏi bookmark',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removeBookmark(story);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? Icons.search_off : Icons.bookmark_border,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Không tìm thấy truyện nào'
                : 'Chưa có truyện bookmark',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Thử tìm kiếm với từ khóa khác'
                : 'Hãy thêm truyện yêu thích vào bookmark',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
