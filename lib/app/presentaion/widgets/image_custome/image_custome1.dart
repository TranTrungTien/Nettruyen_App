import 'package:flutter/material.dart';

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
                // Đã tải xong
                return child;
              } else if (loadingProgress.expectedTotalBytes != null &&
                  loadingProgress.expectedTotalBytes! > 0) {
                // Đang tải
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    value: loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1),
                  ),
                );
              } else {
                // Xử lý lỗi khi không tải được ảnh
                return _buildErrorWidget();
              }
            },
            errorBuilder: (context, error, stackTrace) {
              // Nếu có lỗi trong việc tải ảnh, hiển thị ảnh mặc định
              return _buildErrorWidget();
            },
          )
        : _buildDefaultImage(); // Nếu không có URL, hiển thị ảnh mặc định
  }

  Widget _buildErrorWidget() {
    // Trả về ảnh mặc định khi xảy ra lỗi
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
    // Trả về ảnh mặc định nếu không có URL
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
