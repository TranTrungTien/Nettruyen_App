import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/domain/models/chapter.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/domain/repository/repository_api.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/resources/data_state.dart';
import 'package:minh_nguyet_truyen/setup.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/pagination.dart';

class BodyComicPage extends StatefulWidget {
  const BodyComicPage({super.key, required this.comic});
  final ComicEntity comic;

  @override
  State<BodyComicPage> createState() => _BodyComicPageState();
}

class _BodyComicPageState extends State<BodyComicPage> {
  final _repository = sl<RepositoryApi>();
  int activePage = 1;
  late List<ChapterEntity> _chapters;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chapters = widget.comic.chapters ?? <ChapterEntity>[];
    if (_chapters.isEmpty && (widget.comic.totalChapterPages ?? 0) > 0) {
      _fetchChapters(1);
    }
  }

  Future<void> _fetchChapters(int page) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final dataState = await _repository.getChaptersByPage(
        id: widget.comic.id ?? '0',
        page: page,
      );
      if (!mounted) return;
      if (dataState is DataSuccess && dataState.data != null) {
        setState(() {
          _chapters = dataState.data!;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        // Optionally: show error toast
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.comic.totalChapterPages ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (totalPages > 0)
            Center(
              child: SmartPagination(
                totalPages: totalPages,
                activePage: activePage,
                onPageChanged: (page) {
                  setState(() => activePage = page);
                  _fetchChapters(page);
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Chưa có chương',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(height: 1),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _chapters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final chapter = _chapters[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '${RoutesName.kComics}/${widget.comic.id}/${chapter.id}',
                          arguments: {
                            "comic": widget.comic,
                            "chapter": chapter,
                            "currentChapterPage": activePage,
                            "totalChapterPages": widget.comic.totalChapterPages,
                            "isClickFirstChapter": index == 0,
                            "isClickLastChapter": index == _chapters.length - 1,
                            "defaultChapters": _chapters
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: AppColors.primary),
                          color: index == 0
                              ? AppColors.primary
                              : AppColors.textOnPrimary,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name ?? 'Chương: ${chapter.id}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: index == 0
                                ? AppColors.textOnPrimary
                                : AppColors.primary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
