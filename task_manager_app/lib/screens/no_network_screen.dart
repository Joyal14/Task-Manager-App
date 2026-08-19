import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/empty_view_widget.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_base/res/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_localization.dart';

class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyViewWidget(
        imgPath: Images.nointernet,
        imgHeight: 160.h,
        imgWidth: 160.w,
        txtEmpty: AppLocalizations.of(context)?.translate("txtNoNetwork") ?? '',
        txtSize: 14.sp,
        txtColor: AppColors.black,
      ),
    );
  }
}
