import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class Reload extends StatelessWidget {
  const Reload({super.key, required this.onRetry});

  final Function onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vui lòng tải lại trang",
          style: TextStyle(
              color: AppColors.danger,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
            onPressed: () {
              onRetry();
            },
            icon: const Icon(Icons.cached_outlined,
                color: AppColors.primary, size: 32))
      ],
    );
  }
}
