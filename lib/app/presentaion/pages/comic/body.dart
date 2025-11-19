// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/config/routes/routes_name.dart';

class BodyComicPage extends StatefulWidget {
  BodyComicPage({super.key, required this.comic});
  ComicEntity comic;

  @override
  State<BodyComicPage> createState() => _BodyComicPageState();
}

class _BodyComicPageState extends State<BodyComicPage> {
  int activePage = 1;
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.comic.chapters != null) {
      itemCount = widget.comic.chapters!.length;
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
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
            ),
            itemBuilder: (context, index) {
              final chapter = widget.comic.chapters![index];

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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
        setState(() {
          activePage = page;
        });
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
