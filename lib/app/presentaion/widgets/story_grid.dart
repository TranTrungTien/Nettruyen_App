import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/comic/item_comic_2.dart';

class StoryGrid extends StatelessWidget {
  const StoryGrid({
    super.key,
    required this.stories,
    required this.itemCount,
    this.crossAxisCount = 3,
  });

  final List<ComicEntity> stories;
  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.only(bottom: 20),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ItemComic2(comic: stories[index]);
        },
      ),
    );
  }
}
