import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/presentaion/pages/home/home_page.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/reload.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class ErrorView extends StatelessWidget {
  final String? message;
  final bool shouldShowBackToHome;
  final Function()? onRetry;
  const ErrorView(
      {super.key,
      this.message,
      this.onRetry,
      this.shouldShowBackToHome = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.danger,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Rất tiếc, đã có lỗi xảy ra',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (message != null && message!.isNotEmpty)
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          const SizedBox(height: 20),
          if (onRetry != null)
            Reload(
              onRetry: onRetry!,
            ),
          const SizedBox(height: 20),
          if (shouldShowBackToHome)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home),
              label: const Text('Về trang chủ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
