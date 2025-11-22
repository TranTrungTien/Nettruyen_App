import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nettruyen/core/constants/colors.dart';

// ignore: must_be_immutable
class FailedWidet extends StatefulWidget {
  FailedWidet({super.key, required this.error, this.onReset});
  DioException error;
  Function? onReset;

  @override
  State<FailedWidet> createState() => _FailedWidetState();
}

class _FailedWidetState extends State<FailedWidet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.error.error.toString(),
            style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
                decoration: TextDecoration.none),
          ),
          Text(
            widget.error.message.toString(),
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                decoration: TextDecoration.none),
          ),
          const SizedBox(
            height: 20,
          ),
          widget.onReset != null
              ? IconButton(
                  onPressed: () => widget.onReset,
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                    color: AppColors.danger,
                    size: 50,
                  ))
              : const Spacer()
        ],
      ),
    );
  }
}
