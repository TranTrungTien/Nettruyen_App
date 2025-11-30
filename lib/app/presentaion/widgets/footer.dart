import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/constants.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    int currentYear = currentDateTime.year;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                  text: APP_NAME,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' – nơi đọc truyện online miễn phí với kho truyện tiên hiệp, đô thị, dị giới, sắc hiệp được cập nhật nhanh, giao diện tối ưu cho trải nghiệm đọc mượt mà.',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "©$currentYear. Nội dung được tổng hợp từ các nguồn bên thứ ba. $APP_NAME không sở hữu bản quyền và không chịu trách nhiệm về tính chính xác của nội dung",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
