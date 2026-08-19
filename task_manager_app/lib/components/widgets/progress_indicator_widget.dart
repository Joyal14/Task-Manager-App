import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app_localization.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      width: 180.w,
      padding: const EdgeInsets.all(12),
      color: AppColors.white,
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            SizedBox(
              height: 12.h,
            ),
            Material(
              color: AppColors.white,
              child: Column(
                children: [
                  TextWidget(
                    txtTitle: AppLocalizations.of(context)?.translate("txtLoading") ?? '',
                    txtColor: AppColors.black,
                    txtFontStyle: FontWeight.w500,
                    txtFontSize: 16,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  TextWidget(
                    txtTitle: AppLocalizations.of(context)?.translate("txtPleaseWait") ?? '',
                    txtColor: AppColors.black,
                    txtFontStyle: FontWeight.w500,
                    txtFontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
