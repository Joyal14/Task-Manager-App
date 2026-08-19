import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioButtonWidget extends StatelessWidget {
  final int radioValue;
  final int selectedValue;
  final Function() onSelected;
  final String btnTitle;
  final Color selectedColor;

  const RadioButtonWidget({
    super.key,
    required this.radioValue,
    required this.selectedValue,
    required this.onSelected,
    required this.btnTitle,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextWidget(
          txtTitle: btnTitle,
          txtColor: selectedValue == radioValue ? selectedColor : AppColors.black,
          txtFontStyle: FontWeight.w500,
          txtFontSize: 14.sp,
        ),
        Radio(
          value: radioValue,
          groupValue: selectedValue,
          onChanged: onSelected(),
          activeColor: selectedColor,
        ),
      ],
    );
  }
}
