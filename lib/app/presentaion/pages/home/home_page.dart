import 'package:flutter/material.dart';
import 'package:nettruyen/app/presentaion/pages/genres/body_genre_page.dart';
import 'package:nettruyen/app/presentaion/pages/home/body_home_page.dart';
import 'package:nettruyen/app/presentaion/pages/search/search_page.dart';
import 'package:nettruyen/app/presentaion/pages/page_not_found.dart';
import 'package:nettruyen/app/presentaion/widgets/app_bar/app_bar.dart';
import 'package:nettruyen/app/presentaion/widgets/drawer_home.dart';
import 'package:nettruyen/core/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _listWidget = [
    BodyHomePage(key: UniqueKey()),
    BodyGenrePage(
      key: UniqueKey(),
    ),
  ];
  Widget? _widgetBody;
  @override
  void initState() {
    _widgetBody = _listWidget[0];
    super.initState();
  }

  handleOnPressed() {
    switch (_widgetBody.runtimeType) {
      case BodyHomePage:
        BodyHomePage.loadingData(context);
        break;
      case SearchPage():
        setState(() {
          _widgetBody = SearchPage(key: UniqueKey());
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarWidget(
            title: "Đọc truyện miễn phí",
            onPressed: handleOnPressed,
            isSearch: true),
        drawer: DrawerHome(
          selectedIndex: _selectedIndex,
          onChanged: (selectedIndex) {
            setState(() {
              if (selectedIndex >= _listWidget.length || selectedIndex < 0) {
                _widgetBody = const PageNotFound();
              } else {
                _widgetBody = _listWidget[selectedIndex];
                _selectedIndex = selectedIndex;
              }
            });
          },
        ),
        body: _widgetBody,
      ),
    );
  }
}
