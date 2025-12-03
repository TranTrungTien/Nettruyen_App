import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/domain/models/comic.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/app_bar/app_bar.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/comic/item_comic_2.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/error_view.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/index_page.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/loading_widget.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class ComicListPage<B extends Bloc<ComicEvent, ComicState>>
    extends StatefulWidget {
  const ComicListPage({
    super.key,
    required this.title,
    required this.makeEvent,
  });

  final String title;
  final ComicEvent Function(int page) makeEvent;

  @override
  State<ComicListPage<B>> createState() => _ComicListPageState<B>();
}

class _ComicListPageState<B extends Bloc<ComicEvent, ComicState>>
    extends State<ComicListPage<B>> {
  int totalPages = 1;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<B>().add(widget.makeEvent(1));
  }

  void _loadPage(int page) {
    context.read<B>().add(widget.makeEvent(page));
  }

  Widget _buildGrid(ComicState state) {
    if (state is ComicSuccesfull) {
      final listComic = state.listComic?.comics ?? const <ComicEntity>[];
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.8,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: listComic.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => ItemComic2(comic: listComic[index]),
      );
    }
    if (state is ComicFailed) {
      return ErrorView(
        message: state.error?.message,
        onRetry: () {
          _loadPage(currentPage);
        },
      );
    }
    return const LoadingWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBarWidget(title: widget.title),
      body: BlocConsumer<B, ComicState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(child: _buildGrid(state)),
              IndexPage(
                  totalPages: totalPages,
                  currentPage: currentPage,
                  onValue: (index) {
                    if (index <= totalPages && index >= 0) {
                      setState(() {
                        currentPage = index;
                      });
                    }
                    _loadPage(index);
                  }),
              const SizedBox(height: 10),
            ],
          );
        },
        listener: (BuildContext context, ComicState state) {
          if (state is ComicSuccesfull) {
            setState(() {
              totalPages = state.listComic?.totalPages ?? 1;
            });
          }
        },
      ),
    );
  }
}
