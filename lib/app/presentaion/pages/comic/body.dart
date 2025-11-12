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
  int itemCount = 0;
  int activePage = 1;
  int lengthChapters = 0;

  List<Widget> listRanges = [];
  @override
  void initState() {
    super.initState();
    if (widget.comic.chapters != null) {
      int totalChapterPage = widget.comic.totalChapterPages ?? 0;
      int length = widget.comic.chapters!.length;

      for (var i = 1; i <= totalChapterPage; i++) {
        listRanges.add(_itemChapter(i));
      }

      setState(() {
        itemCount = length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: listRanges),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              height: 1,
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
            ),
            itemBuilder: (context, index) {
              int indexChapter = index;

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      '${RoutesName.kComics}/${widget.comic.id}/${widget.comic.chapters![indexChapter].id}',
                      arguments: <String, dynamic>{
                        "comic": widget.comic,
                        "chapter": widget.comic.chapters![indexChapter]
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: Colors.grey),
                    color: indexChapter == 0 ? Colors.blue : Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.comic.chapters![indexChapter].name,
                    style: TextStyle(
                        color: indexChapter == 0 ? Colors.white : Colors.black,
                        fontSize: 15),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget _itemChapter(int page) {
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
          color: activePage == page ? Colors.green : Colors.white,
        ),
        child: Text(
          "$page",
          style: TextStyle(
              color: activePage == page ? Colors.white : Colors.black,
              fontSize: 15),
        ),
      ),
    );
  }
}
