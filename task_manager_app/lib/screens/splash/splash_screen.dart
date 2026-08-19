import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/components/widgets/text_widget.dart';
import 'package:flutter_base/network/service/navigation_locator.dart';
import 'package:flutter_base/network/service/navigation_service.dart';
import 'package:flutter_base/res/app_colors.dart';
import 'package:flutter_base/screens/home/view/home_screen.dart';
import 'package:flutter_base/screens/onboard/view/login_screen.dart';
import 'package:flutter_base/screens/onboard/view_model/login_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../app_localization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final NavigationService navigationService = locator<NavigationService>();

  Future<void> launchNextScreen(BuildContext context) async {
    var isUserLoggedIn = Provider.of<LoginProvider>(context, listen: false).isUserLoggedIn;
    Timer(const Duration(seconds: 3), () {
      if (isUserLoggedIn) {
        navigationService.pushReplacementAndNavigateTo(HomeScreen.routeName);
      } else {
        navigationService.pushReplacementAndNavigateTo(LoginScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    launchNextScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Align(
        alignment: Alignment.center,
        child: TextWidget(
          txtTitle: AppLocalizations.of(context)?.translate("appName") ?? '',
          txtColor: AppColors.parisGreen,
          txtFontStyle: FontWeight.w700,
          txtFontSize: 24.sp,
        ),
      ),
    );
  }
}
