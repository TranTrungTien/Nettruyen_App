import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColors.primary),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
