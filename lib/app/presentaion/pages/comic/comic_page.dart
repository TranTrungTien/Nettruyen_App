import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/comic_id_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:nettruyen/app/presentaion/pages/comic/body.dart';
import 'package:nettruyen/app/presentaion/pages/comic/heading.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';
import 'package:nettruyen/core/constants/colors.dart';
import 'package:nettruyen/core/utils/noti.dart';

class ComicPage extends StatefulWidget {
  const ComicPage({super.key, required this.comicId});
  final String comicId;

  @override
  State<ComicPage> createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ComicByIdBloc>()
        .add(GetComicByIdEvent(comicId: widget.comicId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicByIdBloc, ComicState>(
      builder: (context, state) {
        if (state is ComicSuccesfull && state.comic != null) {
          final comic = state.comic!;
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              title: Text(
                comic.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.primary),
              ),
              actions: [
                IconButton(
                  onPressed: () => showFeatureComingSoon(context),
                  icon: const Icon(Icons.download),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  HeadingComic(comic: comic),
                  BodyComicPage(comic: comic),
                ],
              ),
            ),
          );
        }
        if (state is ComicFailed) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              title: const Text("Lỗi"),
            ),
            body: FailedWidet(error: state.error!),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundLight,
            title: const LinearProgressIndicator(color: AppColors.primary),
          ),
          body: const LoadingWidget(),
        );
      },
    );
  }
}
