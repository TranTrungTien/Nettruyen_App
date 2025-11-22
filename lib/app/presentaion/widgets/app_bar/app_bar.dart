import 'package:flutter/material.dart';
import 'package:nettruyen/core/constants/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.onPressed,
    this.isSearch,
  });

  final String title;
  final bool? isSearch;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: AppColors.backgroundLight,
      centerTitle: true,
      actions: [
        if (isSearch == true)
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Tìm kiếm',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
