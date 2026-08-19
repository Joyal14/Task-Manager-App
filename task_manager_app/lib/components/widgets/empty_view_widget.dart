import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyViewWidget extends StatelessWidget {
  final String? imgPath;
  final double? imgHeight;
  final double? imgWidth;
  final String txtEmpty;
  final double txtSize;
  final Color txtColor;

  const EmptyViewWidget({
    super.key,
    this.imgPath,
    this.imgHeight,
    this.imgWidth,
    required this.txtEmpty,
    required this.txtSize,
    required this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgPath!,
          fit: BoxFit.scaleDown,
          height: imgHeight,
          width: imgWidth,
        ),
        SizedBox(height: 15.h),
        TextWidget(
          txtTitle: txtEmpty,
          txtColor: txtColor,
          txtFontStyle: FontWeight.w500,
          txtFontSize: txtSize,
          textAlignment: TextAlign.center,
        ),
      ],
    );
  }
}
