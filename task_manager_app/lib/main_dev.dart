import 'package:flutter/material.dart';
import 'package:flutter_base/app_config/app_config.dart';
import 'package:flutter_base/language_constant.dart';
import 'package:flutter_base/network/service/dio_api_helper.dart';
import 'package:flutter_base/network/service/navigation_locator.dart';
import 'package:flutter_base/network/service/navigation_service.dart';
import 'package:flutter_base/screens/home/view/home_screen.dart';
import 'package:flutter_base/screens/home/view_model/home_provider.dart';
import 'package:flutter_base/screens/no_network_screen.dart';
import 'package:flutter_base/screens/onboard/view/login_screen.dart';
import 'package:flutter_base/screens/onboard/view_model/login_provider.dart';
import 'package:flutter_base/screens/splash/splash_screen.dart';
import 'package:flutter_base/utils/network_util.dart';
import 'package:flutter_base/utils/preferences_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'appTheme/app_state_notifier.dart';
import 'appTheme/app_theme.dart';
import 'app_localization.dart';
import 'constants/app_constants.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesUtil.getInstance();
  AppConfig.create(
    appName: "flutter_base",
    baseUrl: DioApiHelper.apiBaseUrlDev,
    imageBaseUrl: DioApiHelper.imageBaseUrlDev,
    onesignalid: DioApiHelper.onesignalidDev,
    flavor: Flavor.dev,
  );
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          create: (ctx) => NetworkUtil().connectionStatusController.stream,
          initialData: ConnectivityStatus.cellular,
        ),
        ChangeNotifierProvider.value(
          value: LoginProvider(),
        ),
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AppStateNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFromPref(context);
    WidgetsBinding.instance.addObserver(this);
  }

  void loadFromPref(BuildContext context) {
    var items = Provider.of<LoginProvider>(context, listen: false);
    items.isUserLoggedIn = PreferencesUtil.getBool(AppConstants.isLoggedin);
  }

  void storeInPref(BuildContext context) {
    debugPrint("state inactive");
    var login = Provider.of<LoginProvider>(context, listen: false);
    PreferencesUtil.setBool(AppConstants.isLoggedin, login.isUserLoggedIn);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      storeInPref(context);
    }
    if (state == AppLifecycleState.resumed) {
      loadFromPref(context);
    }
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return connectionStatus == ConnectivityStatus.offline
        ? ScreenUtilInit(
            useInheritedMediaQuery: true,
            minTextAdapt: true,
            splitScreenMode: false,
            designSize: const Size(360, 800),
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child ?? Container(),
                    );
                  },
                  home: const NoNetworkScreen());
            })
        : Consumer<AppStateNotifier>(
            builder: (context, appState, child) => ScreenUtilInit(
                useInheritedMediaQuery: true,
                minTextAdapt: false,
                designSize: const Size(360, 800),
                builder: (context, Widget? child) {
                  return MaterialApp(
                    //title: Strings.appName,
                    navigatorKey: locator<NavigationService>().navigatorKey,
                    debugShowCheckedModeBanner: false,
                    themeMode: appState.appMode ? ThemeMode.dark : ThemeMode.light,
                    darkTheme: AppTheme.darkTheme,
                    theme: AppTheme.lightTheme,
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supportedLocales) {
                      // Check if the current device locale is supported
                      for (var supportedLocale in supportedLocales) {
                        if (supportedLocale.languageCode == locale?.languageCode && supportedLocale.countryCode == locale?.countryCode) {
                          return supportedLocale;
                        }
                      }

                      return supportedLocales.first;
                    },
                    supportedLocales: const [
                      Locale('en', 'US'),
                    ],
                    locale: _locale,
                    home: const SplashScreen(),
                    routes: {
                      LoginScreen.routeName: (ctx) => const LoginScreen(),
                      HomeScreen.routeName: (ctx) => const HomeScreen(),
                    },
                  );
                }),
          );
  }
}
