// search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/blocs/search_comic_bloc.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:nettruyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:nettruyen/app/presentaion/widgets/comic/item_comic_2.dart';
import 'package:nettruyen/app/presentaion/widgets/failed_widget.dart';
import 'package:nettruyen/app/presentaion/widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _currentQuery = '';
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return; // bảo vệ context sau async gap

      final args = ModalRoute.of(context)?.settings.arguments;
      print('args $args');
      if (args is String) {
        final newQuery = args.trim();
        if (newQuery.isNotEmpty) {
          _search(newQuery, page: 1);
          setState(() {
            _currentQuery = newQuery;
            _currentPage = 1;
          });
        }
      }
    });
  }

  void _search(String query, {int page = 1}) {
    // Log ra query đang được dùng để tìm kiếm.
    print('Searching for: "$query" on page $page');
    context.read<SearchComicBloc>().add(GetComicsSearchEvent(
          query: query,
          page: page,
        ));
  }

  void _loadMore() {
    if (_currentPage < _totalPages) {
      // Gọi tìm kiếm cho trang tiếp theo.
      // State của _currentPage sẽ được cập nhật trong listener của BlocConsumer.
      _search(_currentQuery, page: _currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SearchComicBloc, ComicState>(
        listener: (context, state) {
          if (state is ComicSuccesfull && state.listComic != null) {
            setState(() {
              _totalPages = state.listComic!.total_pages ?? 1;
              _currentPage = state.listComic!.current_page ?? 1;
            });
          }
        },
        builder: (context, state) {
          // 1. Đang load trang đầu
          if (state is ComicLoading) {
            return const LoadingWidget();
          }

          // 2. Lỗi
          if (state is ComicFailed) {
            return FailedWidet(error: state.error!);
          }

          // 3. Thành công
          if (state is ComicSuccesfull && state.listComic?.comics != null) {
            final comics = state.listComic!.comics!;

            if (comics.isEmpty) {
              return const Center(
                child: Text(
                  'Không tìm thấy kết quả',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              // Hiển thị loading indicator ở cuối nếu còn trang
              itemCount: comics.length + ((_currentPage < _totalPages) ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == comics.length) {
                  _loadMore();
                  return const Center(child: CircularProgressIndicator());
                }
                return ItemComic2(comic: comics[index]);
              },
            );
          }

          // 4. Chưa có dữ liệu (vừa vào, chưa search)
          return const Center(
            child: Text(
              'Nhập từ khóa để tìm kiếm',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
