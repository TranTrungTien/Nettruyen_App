import 'package:flutter/material.dart';

class NotFoundIcon extends StatelessWidget {
  const NotFoundIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image(
          image: AssetImage("assets/icons/not_found_icon.png"),
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
