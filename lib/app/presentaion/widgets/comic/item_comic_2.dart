import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/image_custome/image_custome.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/api.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class ItemComic2 extends StatefulWidget {
  final ComicEntity comic;

  const ItemComic2({super.key, required this.comic});

  @override
  State<ItemComic2> createState() => _ItemComic2State();
}

class _ItemComic2State extends State<ItemComic2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '${RoutesName.kComics}/${widget.comic.id}',
            arguments: widget.comic.id);
      },
      child: Container(
        width: 100,
        color: Colors.white,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            ImageCustome(
              url: widget.comic.thumbnail != ''
                  ? "$kBaseURL/images?src=${Uri.encodeComponent(widget.comic.thumbnail ?? '')}"
                  : "",
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Visibility(
                visible: true,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 20,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.hotTag,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    "Hot",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              color: const Color.fromARGB(182, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comic.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.library_books_outlined,
                                size: 10, color: AppColors.textOnPrimary),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                widget.comic.totalChapters?.toString() ?? '0',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.signal_cellular_alt_outlined,
                                size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                widget.comic.status ?? "Đạng cập nhật",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
