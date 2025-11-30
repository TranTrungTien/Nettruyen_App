import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/domain/models/genre.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class Genres extends StatelessWidget {
  const Genres({super.key, required this.genres});
  final List<GenreEntity> genres;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: genres.map((g) {
        final value = g.name ?? "";
        return Container(
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.primary),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(value,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        );
      }).toList(),
    );
  }
}
