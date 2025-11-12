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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty && args != _currentQuery) {
      setState(() {
        _currentQuery = args.trim();
        _currentPage = 1;
      });
      _search(_currentQuery, page: 1);
    }
  }

  void _search(String query, {int page = 1}) {
    context.read<SearchComicBloc>().add(GetComicsSearchEvent(
          query: query,
          page: page,
        ));
  }

  void _loadMore() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      _search(_currentQuery, page: _currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_currentQuery.isEmpty ? 'Tìm kiếm' : 'Tìm: "$_currentQuery"'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Gọi dialog từ bên ngoài (showSearchInputDialog)
              // Không xử lý ở đây → giữ trang sạch
            },
          ),
        ],
      ),
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
          if (state is ComicLoading && _currentPage == 1) {
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
              itemCount: comics.length + (_currentPage < _totalPages ? 1 : 0),
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
