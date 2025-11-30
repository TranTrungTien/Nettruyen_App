import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/genre.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/image_custome/image_custome.dart';
import 'package:minh_nguyet_truyen/config/routes/routes_name.dart';
import 'package:minh_nguyet_truyen/core/constants/api.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';
import 'package:minh_nguyet_truyen/core/utils/noti.dart';

class HeadingComic extends StatefulWidget {
  const HeadingComic({super.key, required this.comic});
  final ComicEntity comic;

  @override
  State<HeadingComic> createState() => _HeadingComicState();
}

class _HeadingComicState extends State<HeadingComic> {
  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    final hasThumb = widget.comic.thumbnail?.isNotEmpty ?? false;
    final thumbUrl = hasThumb
        ? "$kBaseURL/images?src=${Uri.encodeComponent(widget.comic.thumbnail!)}"
        : "";

    Widget? genresWidget = Genres(genres: widget.comic.genres ?? []);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.comic.title ?? "",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCustome2(
                url: thumbUrl,
                margin: const EdgeInsets.only(right: 10),
                width: 150,
                height: 200,
                borderRadius: BorderRadius.circular(10),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    genresWidget,
                    Row(
                      children: [
                        const Text("Chương:",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.comic.totalChapters?.toString() ?? "0",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Yêu thích
                    const Row(
                      children: [
                        Text("Nguồn:",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Sưu tầm",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Trạng thái
                    Row(
                      children: [
                        const Text("Trạng thái:",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.comic.status ?? "Đang cập nhật",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Tác giả
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Tác giả: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                widget.comic.authors ?? "Đang cập nhật",
                style:
                    const TextStyle(fontSize: 15, color: AppColors.textPrimary),
              )
            ],
          ),
          const Text(
            "Nội dung truyện: ",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.comic.description!.isNotEmpty
                ? widget.comic.description!
                : 'Đang cập nhật',
            overflow: TextOverflow.ellipsis,
            maxLines: isShowMore ? 1000 : 3,
            style:
                const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          if (widget.comic.description != '')
            InkWell(
              onTap: () => setState(() => isShowMore = !isShowMore),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: AppColors.primary),
                ),
                child: Text(!isShowMore ? "Xem thêm" : "Thu nhỏ"),
              ),
            ),
          // Nút hành động
          Wrap(
            children: [
              // Đọc từ đầu (guard chapters)
              InkWell(
                onTap: () {
                  final chaps = widget.comic.chapters ?? [];
                  if (chaps.isNotEmpty) {
                    final first = chaps.first;
                    Navigator.pushNamed(
                      context,
                      '${RoutesName.kComics}/${widget.comic.id}/${first.id}',
                      arguments: <String, dynamic>{
                        "comic": widget.comic,
                        "chapter": first,
                      },
                    );
                  } else {
                    showFeatureComingSoon(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.primary),
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primary,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, color: AppColors.textOnPrimary),
                      Text(
                        " Đọc từ đầu",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => showFeatureComingSoon(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.primary),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fiber_new, color: AppColors.primary),
                      Text(
                        " Đọc mới nhất",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: InkWell(
                  onTap: () => showFeatureComingSoon(context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.secondary),
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.secondary,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Đọc tiếp ",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        Icon(Icons.navigate_next,
                            color: AppColors.textOnPrimary),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
