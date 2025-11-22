import 'package:flutter/material.dart';

class AppColors {
  // Màu Sắc Chính (Primary Colors)
  static const Color primary = Color(0xFF008080); // Xanh Ngọc Bích Đậm
  static const Color secondary = Color(0xFFFFB347); // Cam Đất Nhạt (Accent)

  // Màu Nền (Background Colors)
  // Màu Nền Chính (Light Mode) - Giảm độ chói
  static const Color backgroundLight = Color(0xFFFAFAF5); // Trắng Ngà/Kem
  // Màu Nền Chính (Dark Mode) - Xám than chì
  static const Color backgroundDark = Color(0xFF121212);

  // Màu Chữ (Text Colors)
  // Màu chữ chính (Tiêu đề, nội dung đọc)
  static const Color textPrimary = Color(0xFF1A1A1A); // Xám Đen Sâu
  // Màu chữ phụ (Mô tả, thông tin nhỏ)
  static const Color textSecondary = Color(0xFF666666); // Xám Tro Nhạt
  // Màu chữ cho nền tối/màu primary
  static const Color textOnPrimary = Colors.white;

  // Màu Trạng Thái (Status Colors)
  static const Color success =
      Color(0xFF5CB85C); // Xanh Lá Mạ (Full/Thành công)
  static const Color danger = Color(0xFFD9534F); // Đỏ Đất (Đọc tiếp/Cảnh báo)
  static const Color hotTag =
      Color(0xFFFFB347); // Dùng lại Secondary cho Tag "HOT"
}
