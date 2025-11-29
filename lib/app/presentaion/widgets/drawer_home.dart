import 'package:flutter/material.dart';
import 'package:nettruyen/core/constants/colors.dart';
import 'package:nettruyen/core/constants/constants.dart';
import 'package:nettruyen/core/utils/noti.dart';

// ignore: must_be_immutable
class DrawerHome extends StatefulWidget {
  DrawerHome({super.key, required this.selectedIndex, required this.onChanged});
  final int selectedIndex;

  void Function(int indexSelect) onChanged;

  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  @override
  Widget build(BuildContext context) {
    final int indexSelect = widget.selectedIndex;
    return Drawer(
      backgroundColor: AppColors.backgroundLight,
      child: Column(
        children: [
          const ListTile(
            selected: true,
            selectedTileColor: AppColors.primary,
            title: Text(
              APP_NAME,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              widget.onChanged(0);
              Navigator.pop(context);
            },
            selected: indexSelect == 0,
            selectedTileColor: AppColors.primary,
            leading: Icon(Icons.home_outlined,
                color: indexSelect == 0
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary),
            title: Text(
              "Trang chủ",
              style: TextStyle(
                  fontSize: 20,
                  color: indexSelect == 0
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary),
            ),
          ),
          ListTile(
            onTap: () {
              widget.onChanged(1);
              Navigator.pop(context);
            },
            selected: indexSelect == 1,
            selectedTileColor: AppColors.primary,
            leading: Icon(Icons.category_outlined,
                color: indexSelect == 1
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary),
            title: Text(
              "Thể loại",
              style: TextStyle(
                  fontSize: 20,
                  color: indexSelect == 1
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary),
            ),
          ),
          ListTile(
            onTap: () {
              showFeatureComingSoon(context);
              Navigator.pop(context);
              //   widget.onChanged(2);
            },
            selected: indexSelect == 2,
            selectedTileColor: AppColors.primary,
            leading: Icon(Icons.book_outlined,
                color: indexSelect == 2
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary),
            title: Text(
              "Truyện mới",
              style: TextStyle(
                  fontSize: 20,
                  color: indexSelect == 2
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary),
            ),
          ),
          ListTile(
            onTap: () {
              showFeatureComingSoon(context);
              Navigator.pop(context);
              //   widget.onChanged(3);
            },
            selected: indexSelect == 3,
            selectedTileColor: AppColors.primary,
            leading: Icon(Icons.hotel_class_outlined,
                color: indexSelect == 3
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary),
            title: Text(
              "Xếp hạng",
              style: TextStyle(
                  fontSize: 20,
                  color: indexSelect == 3
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary),
            ),
          ),
          ListTile(
            onTap: () {
              showFeatureComingSoon(context);
              Navigator.pop(context);
              //   widget.onChanged(4);
            },
            selected: indexSelect == 4,
            selectedTileColor: AppColors.primary,
            leading: Icon(Icons.history_outlined,
                color: indexSelect == 4
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary),
            title: Text(
              "Lịch sử",
              style: TextStyle(
                  fontSize: 20,
                  color: indexSelect == 4
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary),
            ),
          ),
          ListTile(
            onTap: () {
              showFeatureComingSoon(context);
              Navigator.pop(context);
            },
            leading: const Icon(Icons.exit_to_app_outlined,
                color: AppColors.textPrimary),
            title: const Text(
              "Thoát",
              style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
