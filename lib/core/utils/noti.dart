import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

void showFeatureComingSoon(BuildContext context) {
  const snackBar = SnackBar(
    content: Text(
      'Tính năng này sẽ sớm ra mắt! Vui lòng quay lại sau.',
      style: TextStyle(color: AppColors.textOnPrimary),
    ),
    backgroundColor: AppColors.secondary,
    duration: Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
  );

  // Hiển thị SnackBar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
