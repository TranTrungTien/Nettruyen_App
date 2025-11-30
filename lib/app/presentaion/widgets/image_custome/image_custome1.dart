import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

// ignore: must_be_immutable
class ImageCustome extends StatelessWidget {
  ImageCustome({super.key, this.url});
  String? url;

  @override
  Widget build(BuildContext context) {
    return url != null
        ? Image.network(
            url!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else if (loadingProgress.expectedTotalBytes != null &&
                  loadingProgress.expectedTotalBytes! > 0) {
                // Đang tải
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    value: loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1),
                  ),
                );
              } else {
                return _buildErrorWidget();
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          )
        : _buildDefaultImage();
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/error_image.png"),
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }

  Widget _buildDefaultImage() {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/error_image.png"),
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
