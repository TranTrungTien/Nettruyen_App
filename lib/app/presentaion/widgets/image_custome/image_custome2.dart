import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/app/presentaion/widgets/loading_widget.dart';
import 'package:minh_nguyet_truyen/core/constants/constants.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

// ignore: must_be_immutable
class ImageCustome2 extends StatefulWidget {
  ImageCustome2({
    super.key,
    this.url,
    this.backgroundColor,
    this.margin,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.fit,
    this.onError,
  });
  String? url;
  EdgeInsetsGeometry? margin;
  BorderRadiusGeometry? borderRadius;
  BoxBorder? border;
  Color? backgroundColor;
  double? width;
  double? height;
  BoxFit? fit;
  void Function(String error)? onError;

  @override
  State<ImageCustome2> createState() => _ImageCustome2State();
}

class _ImageCustome2State extends State<ImageCustome2> {
  Status status = Status.loading;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        if (mounted && status != Status.error) {
          setState(() {
            status = Status.succesfull;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget.url != null
              ? NetworkImage(widget.url!)
              : const AssetImage("assets/images/error_image.png")
                  as ImageProvider,
          onError: (exception, stackTrace) {
            if (mounted) {
              setState(() {
                status = Status.error;
              });
            }
            if (widget.onError != null) {
              widget.onError!(exception.toString());
            }
          },
          fit: widget.fit ?? BoxFit.cover,
        ),
        borderRadius: widget.borderRadius,
        color: widget.backgroundColor,
        border: widget.border,
      ),
      child: Stack(
        children: [
          if (status == Status.loading) const LoadingWidget(),
          if (status == Status.error)
            const Center(
              child: Icon(
                Icons.bug_report,
                color: AppColors.danger,
              ),
            ),
        ],
      ),
    );
  }
}
