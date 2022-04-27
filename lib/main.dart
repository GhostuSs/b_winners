import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_bet/data/app_settings/navigation/routes.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';
import 'package:quiz_bet/ui/screens/profile/models/profile_model.dart';
import 'package:quiz_bet/ui/screens/quiz/models/limit_model/limit_model.dart';

import 'data/app_settings/color_pallete/colors.dart';

bool seen = false;
bool premium = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
  [DeviceOrientation.portraitUp]);
  Directory directory = Directory.current;
  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }
  Hive.init(directory.path);
  Hive.registerAdapter<HiveResult>(HiveResultAdapter());
  Hive.registerAdapter<LimitsHive>(LimitsHiveAdapter());
  Hive.registerAdapter<ProfileStat>(ProfileStatAdapter());
  final onboardingSeen = await Hive.openBox<bool>('seen');
  final prem = await Hive.openBox<bool>('premium');
  if (onboardingSeen.values.isEmpty) await onboardingSeen.put('seen', false);
  seen = onboardingSeen.values.first;
  if (prem.values.isEmpty) await prem.put('premium', false);
  // final sd = await Hive.openBox('limits');
  // await sd.clear();
  // await prem.clear();
  premium = prem.values.first;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: () => MaterialApp(
        darkTheme: ThemeData(
          selectedRowColor: AppColors.usualBlue,
          unselectedWidgetColor: AppColors.usualBlue.withOpacity(0.3),
        ),
        routes: routes,
        initialRoute: seen==true && premium==true
            ? MainNavigationRoutes.main
            : MainNavigationRoutes.onboarding,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: AppColors.usualBlue,
              selectedLabelStyle: TextStyle(
                  fontFamily: 'MontBold',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h),
              showUnselectedLabels: true,
              showSelectedLabels: true,
              unselectedItemColor:AppColors.usualBlue.withOpacity(0.3),
              unselectedLabelStyle: TextStyle(
                  color: AppColors.usualBlue.withOpacity(0.3),
                  fontFamily: 'MontBold',
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h),
              unselectedIconTheme: IconThemeData(color: AppColors.usualBlue.withOpacity(0.3),)),
          textTheme: TextTheme(
              button: TextStyle(
            fontSize: 45.sp,
          )),
        ),
          ),
    );
  }
}
