import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/gen/assets.gen.dart';
import 'package:quiz_bet/main.dart';
import 'package:quiz_bet/ui/screens/onboarding/ui/onboarding_screen.dart';
import 'package:quiz_bet/ui/screens/webview/web.dart';
import 'package:quiz_bet/ui/uikit/xbet_label.dart';
import 'package:quiz_bet/ui/uikit/settings_button.dart';
import '../../../data/app_settings/color_pallete/colors.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF041B47),
            Color(0xFF031434),
          ],
        )),
        child: Center(
          child: Column(
            children: <Widget>[
              BWinLabel(),
              Divider(
                color: AppColors.white.withOpacity(0.3),
              ),
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SettingsButton(
                  icon: Assets.images.buyPremium.svg(),
                  label: 'Buy premium',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OnBoardingScreen())),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SettingsButton(
                  onPressed: () => openPrivacyPolicy(),
                  icon: Assets.images.privacyPolicy.svg(),
                  label: 'Privacy policy',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SettingsButton(
                  onPressed: () =>openTermsOfUse(),
                  icon: Assets.images.termsOfUse.svg(),
                  label: 'Terms of use',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SettingsButton(
                  icon: Assets.images.support.svg(),
                  onPressed: ()=>openSupport(),
                  label: 'Support',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SettingsButton(
                  icon: Assets.images.rateApp.svg(),
                  label: 'Rate app',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
