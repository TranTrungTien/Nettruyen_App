// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/domain/repository/repository_api.dart';
import 'package:nettruyen/config/routes/routes_name.dart';
import 'package:nettruyen/core/resources/data_state.dart';
import 'package:nettruyen/setup.dart';

class BodyComicPage extends StatefulWidget {
  BodyComicPage({super.key, required this.comic});
  ComicEntity comic;

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
    _chapters = widget.comic.chapters ?? [];
  }

  void _fetchChapters(int page) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final dataState = await _repository.getChaptersByPage(
      id: widget.comic.id ?? '0',
      page: page,
    );

    if (dataState is DataSuccess && dataState.data != null) {
      if (mounted) {
        setState(() {
          _chapters = dataState.data!;
          _isLoading = false;
        });
      }
    } else {
      // Handle error state if needed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.comic.totalChapterPages ?? 0;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: List.generate(
              totalPages,
              (i) => _itemChapter(i + 1),
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
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Colors.grey),
                          color: index == 0 ? Colors.blue : Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name ?? 'Chương: ${chapter.id}',
                          style: TextStyle(
                            color: index == 0 ? Colors.white : Colors.black,
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

  Widget _itemChapter(int page) {
    final isActive = activePage == page;

    return InkWell(
      onTap: () {
        if (!isActive) {
          setState(() {
            activePage = page;
          });
          _fetchChapters(page);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey),
          color: isActive ? Colors.green : Colors.white,
        ),
        child: Text(
          "$page",
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
