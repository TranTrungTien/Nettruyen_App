import 'package:flutter/material.dart';
import 'package:nettruyen/utils/index.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title, this.onPressed});
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: onPressed,
            icon: IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, RoutesName.kSearch);
                showSearchInputDialog(context: context);
              },
              icon: const Icon(Icons.search_outlined, color: Colors.black),
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
