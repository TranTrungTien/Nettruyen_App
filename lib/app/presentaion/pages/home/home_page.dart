import 'package:flutter/material.dart';
import 'package:nettruyen/app/presentaion/pages/genres/body_genre_page.dart';
import 'package:nettruyen/app/presentaion/pages/home/body_home_page.dart';
import 'package:nettruyen/app/presentaion/pages/new_comic/body_newComic_page.dart';
import 'package:nettruyen/app/presentaion/pages/search/search_page.dart';
import 'package:nettruyen/app/presentaion/pages/page_not_found.dart';
import 'package:nettruyen/app/presentaion/widgets/drawer_home.dart';
import 'package:nettruyen/utils/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _listWidget = [
    BodyHomePage(key: UniqueKey()),
    BodyGenrePage(
      key: UniqueKey(),
    ),
    BodyNewComicPage(
      key: UniqueKey(),
    ),
    SearchPage(
      key: UniqueKey(),
    )
  ];
  Widget? _widgetBody;
  @override
  void initState() {
    _widgetBody = _listWidget[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Đọc truyện miễn phí",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.amber[700], fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  switch (_widgetBody.runtimeType) {
                    case BodyHomePage:
                      BodyHomePage.loadingData(context);
                      break;
                    case BodyGenrePage:
                      setState(() {
                        _widgetBody = BodyGenrePage(key: UniqueKey());
                      });
                      break;
                    case BodyNewComicPage:
                      setState(() {
                        _widgetBody = BodyNewComicPage(key: UniqueKey());
                      });
                      break;
                    case SearchPage():
                      setState(() {
                        _widgetBody = SearchPage(key: UniqueKey());
                      });
                      break;
                  }
                },
                icon: IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, RoutesName.kSearch);
                    showSearchInputDialog(context: context);
                  },
                  icon: const Icon(Icons.search_outlined, color: Colors.black),
                ))
          ],
        ),
        drawer: DrawerHome(
          onChanged: (indexSelect) {
            setState(() {
              if (indexSelect >= _listWidget.length || indexSelect < 0) {
                _widgetBody = const PageNotFound();
              } else {
                _widgetBody = _listWidget[indexSelect];
              }
            });
          },
        ),
        body: _widgetBody,
      ),
    );
  }
}
