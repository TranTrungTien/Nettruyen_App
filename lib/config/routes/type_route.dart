import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_event.dart';
import 'package:minh_nguyet_truyen/app/presentaion/blocs/remote/comic/comic_state.dart';
import 'package:minh_nguyet_truyen/app/presentaion/pages/page_list_comic_by_bloc.dart';
import 'package:minh_nguyet_truyen/setup.dart';

PageRoute typedListRoute<B extends Bloc<ComicEvent, ComicState>>({
  required String title,
  required ComicEvent Function(int page) makeEvent,
  RouteSettings? settings,
}) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) {
      return BlocProvider<B>(
        create: (_) => sl<B>(),
        child: ComicListPage<B>(
          title: title,
          makeEvent: makeEvent,
        ),
      );
    },
  );
}
