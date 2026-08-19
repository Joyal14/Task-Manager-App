import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/button_widget.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogWidget extends StatelessWidget {
  final String alertTitle;
  final String yesText;
  final String noText;
  final Function() onYesPressed;
  final Function() onNoPressed;

  const DialogWidget({
    super.key,
    required this.alertTitle,
    required this.yesText,
    required this.noText,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextWidget(
        txtTitle: alertTitle,
        txtColor: AppColors.black,
        txtFontStyle: FontWeight.w500,
        txtFontSize: 14.sp,
      ),
      actions: [
        ButtonWidget(
          isLeftIconRequired: false,
          isRightIconRequired: false,
          btnTitle: noText,
          horizontalPadding: 12.w,
          verticalPadding: 12.h,
          borderRadius: 0,
          btnColor: AppColors.white,
          txtColor: AppColors.dimGrey,
          txtSize: 14,
          btnElevation: 0,
          isBorderedButton: false,
          onClicked: onNoPressed,
        ),
        ButtonWidget(
          isLeftIconRequired: false,
          isRightIconRequired: false,
          btnTitle: yesText,
          horizontalPadding: 12.w,
          verticalPadding: 12.h,
          borderRadius: 0.r,
          btnColor: AppColors.white,
          txtColor: AppColors.sapphireBlue,
          txtSize: 14.sp,
          btnElevation: 0,
          isBorderedButton: false,
          onClicked: onYesPressed,
        ),
      ],
    );
  }
}
