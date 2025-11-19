// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hidable/hidable.dart';
import 'package:nettruyen/app/domain/models/chapter.dart';
import 'package:nettruyen/app/domain/models/comic.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/chapter/chapter_state.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';

class ChapterComicPage extends StatefulWidget {
  ChapterComicPage({super.key, required this.comic, required this.chapter});
  ComicEntity comic;
  ChapterEntity chapter;

  @override
  State<ChapterComicPage> createState() => _ChapterComicPageState();
}

class _ChapterComicPageState extends State<ChapterComicPage> {
  final _scrollController = ScrollController();
  ChapterEntity chapter = ChapterEntity(id: '0', name: "");
  @override
  void initState() {
    super.initState();
    chapter = widget.chapter;
    context.read<ChapterBloc>().add(GetContentChapterEvent(
        chapterId: widget.chapter.id, comic: widget.comic));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ChapterBloc, ChapterState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: Hidable(
                controller: _scrollController,
                deltaFactor: 1,
                child: AppBar(
                    title: ListTile(
                  title: Text(
                    widget.comic.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    chapter.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ),
              body: buildBody(state),
              bottomNavigationBar: Hidable(
                controller: _scrollController,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.redAccent,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {
                              var chapters = state.contentChapter?.chapters;
                              if (chapters == null) return;

                              var index = chapters
                                  .indexWhere((e) => e.id == chapter.id);

                              if (index > 0) {
                                final prevChapter = chapters[index - 1];

                                context.read<ChapterBloc>().add(
                                    GetContentChapterEvent(
                                        chapterId: prevChapter.id,
                                        comic: widget.comic));
                                setState(() {
                                  chapter = prevChapter;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.redAccent,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {
                              var chapters = state.contentChapter?.chapters;
                              if (chapters == null) return;
                              int index = chapters
                                  .indexWhere((e) => e.id == chapter.id);
                              var length = chapters.length;
                              if (index < length - 1) {
                                final nextChapter = chapters[index + 1];
                                context.read<ChapterBloc>().add(
                                    GetContentChapterEvent(
                                        chapterId: nextChapter.id,
                                        comic: widget.comic));
                                setState(() {
                                  chapter = nextChapter;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildBody(ChapterState state) {
    if (state is ChapterSuccessfull) {
      final content = state.contentChapter?.content ?? '';
      return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5, // Khoảng cách dòng
          ),
        ),
      );
    }

    if (state is ChapterFailed) {
      return FailedWidet(error: state.error!);
    }

    return const LoadingWidget();
  }
}
