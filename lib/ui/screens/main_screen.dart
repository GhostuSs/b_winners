import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/ui/screens/profile/ui/profile_Screen.dart';
import 'package:quiz_bet/ui/screens/settings/settings_screen.dart';
import '../../data/app_settings/color_pallete/colors.dart';
import '../../gen/assets.gen.dart';
import 'home/home.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [HomeScreen(), ProfileScreen(),SettingsScreen()];
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black.withOpacity(0.84)))),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Assets.images.quiz
                        .svg(color: AppColors.usualBlue.withOpacity(0.3),width: 30.w,height: 30.h),
                    label: 'Quiz',
                    activeIcon: Assets.images.quiz.svg(color: AppColors.usualBlue,width: 30.w,height: 30.h)),
                BottomNavigationBarItem(
                    icon: Assets.images.profile.svg(color: AppColors.usualBlue.withOpacity(0.3),width: 30.w,height: 30.h),
                    label: 'Profile',
                    activeIcon: Assets.images.profile.svg(color: AppColors.usualBlue,width: 30.w,height: 30.h)),
                BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Assets.images.settings.svg(
                        color: AppColors.usualBlue.withOpacity(0.3),
                        width: 30.w,
                        height: 30.h),
                    activeIcon: Assets.images.settings.svg(
                        color: AppColors.usualBlue, width: 30.w, height: 30.h)),
              ],
              backgroundColor: AppColors.darkblue,
              unselectedLabelStyle: TextStyle(
                fontFamily: 'MontBold',
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A66FFB2).withOpacity(0.3),
                fontSize: 12.h,
              ),
              currentIndex: currIndex,
              onTap: (index) {
                setState(() {
                  currIndex = index;
                });
              },
            ),
          ),
          body: Container(
            child: screens[currIndex],
          ),
        ),
        onWillPop: () async => false);
  }
}
