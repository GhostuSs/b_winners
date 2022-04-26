import 'package:flutter/material.dart';
import '../../../ui/screens/main_screen.dart';
import '../../../ui/screens/onboarding/ui/onboarding_screen.dart';

abstract class MainNavigationRoutes {
  static const String main = '/';
  static const String onboarding = '/onboarding';
}

final routes = {
  MainNavigationRoutes.main: (BuildContext context) => MainScreen(),
  MainNavigationRoutes.onboarding: (BuildContext context) =>
      const OnBoardingScreen(),
};
