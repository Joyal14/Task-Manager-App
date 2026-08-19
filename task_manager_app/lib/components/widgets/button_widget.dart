import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final bool isLeftIconRequired;
  final bool isRightIconRequired;
  final String? iconImage;
  final String btnTitle;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final Color btnColor;
  final Color txtColor;
  final double txtSize;
  final double? btnElevation;
  final bool isBorderedButton;
  final Function() onClicked;

  const ButtonWidget({
    super.key,
    required this.isLeftIconRequired,
    required this.isRightIconRequired,
    this.iconImage,
    required this.btnTitle,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.btnColor,
    required this.txtColor,
    required this.txtSize,
    this.btnElevation,
    required this.isBorderedButton,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: isBorderedButton
            ? BorderSide(
                color: txtColor,
                width: 1.5.w,
                style: BorderStyle.solid,
              )
            : BorderSide.none,
      ),
      color: btnColor,
      elevation: btnElevation,
      onPressed: onClicked,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLeftIconRequired
              ? Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Image.asset(
                    iconImage!,
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(),
          TextWidget(
            txtTitle: btnTitle,
            txtColor: txtColor,
            txtFontStyle: FontWeight.w500,
            txtFontSize: txtSize,
          ),
          isRightIconRequired
              ? Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Image.asset(
                    iconImage!,
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
