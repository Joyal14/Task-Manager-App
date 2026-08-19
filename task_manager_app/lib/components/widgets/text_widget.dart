import 'package:flutter/material.dart';
import 'package:flutter_base/res/fonts.dart';

class TextWidget extends StatelessWidget {
  final String txtTitle;
  final Color txtColor;
  final FontWeight txtFontStyle;
  final double txtFontSize;
  final TextAlign? textAlignment;

  const TextWidget({
    super.key,
    required this.txtTitle,
    required this.txtColor,
    required this.txtFontStyle,
    required this.txtFontSize,
    this.textAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txtTitle,
      style: TextStyle(
        color: txtColor,
        fontFamily: Fonts.fontPoppins,
        fontWeight: txtFontStyle,
        fontSize: txtFontSize,
      ),
      textAlign: textAlignment ?? TextAlign.start,
    );
  }
}
