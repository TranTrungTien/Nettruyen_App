import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/presentaion/widgets/comic/item_comic_2.dart';
import 'package:nettruyen/app/presentaion/widgets/not_found_icon.dart';
import 'package:nettruyen/core/constants/colors.dart';

// ignore: must_be_immutable
class GridViewComics extends StatelessWidget {
  GridViewComics(
      {super.key,
      this.listValue,
      this.itemCount = 0,
      required this.title,
      required this.icon,
      required this.onPressedShowAll,
      this.iconColor,
      this.titleColor,
      this.crossAxisCount = 3});
  List<ComicEntity>? listValue;
  String title;
  IconData icon;
  Function onPressedShowAll;
  Color? iconColor;
  Color? titleColor;
  int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    log(listValue.toString());
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 10),
          leading: Icon(
            icon,
            size: 30,
            color: iconColor ?? AppColors.primary,
          ),
          trailing: TextButton(
            onPressed: () => onPressedShowAll(),
            child: const Icon(Icons.chevron_right,
                size: 30, color: AppColors.primary),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: titleColor),
          ),
        ),
        buildBody(),
      ],
    );
  }

  Widget buildBody() {
    if (listValue == null) return const SizedBox();

    if (listValue!.isEmpty) {
      return const NotFoundIcon();
    }
    return Container(
      height: listValue!.isNotEmpty ? 400 : 10,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.4,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (listValue!.length >= itemCount) {
            return ItemComic2(comic: listValue![index]);
          } else {
            return Container(
              color: AppColors.backgroundLight,
            );
          }
        },
      ),
    );
  }
}
