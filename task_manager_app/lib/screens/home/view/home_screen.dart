import 'package:flutter/material.dart';
import 'package:flutter_base/app_localization.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_base/screens/home/view_model/home_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home_screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          txtColor: AppColors.black,
          txtTitle: AppLocalizations.of(context)?.translate("appName") ?? '',
          txtFontSize: 18.sp,
          txtFontStyle: FontWeight.w600,
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (ctx, data, _) => Center(
          child: TextWidget(
            txtColor: AppColors.black,
            txtTitle: AppLocalizations.of(context)?.translate("appName") ?? '',
            txtFontSize: 14.sp,
            txtFontStyle: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
