import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/data/app_settings/navigation/routes.dart';
import 'package:quiz_bet/gen/assets.gen.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';
import 'package:quiz_bet/ui/screens/profile/models/profile_model.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({
    required this.result,
    required this.indexOfQuiz,
  });

  final int result;
  final int indexOfQuiz;

  @override
  State<StatefulWidget> createState() {
    return _ResultScreenState();
  }
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: AppColors.darkblue.withOpacity(0.3),
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black.withOpacity(0.84)))),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Assets.images.quiz
                        .svg(color: AppColors.usualBlue.withOpacity(0.3)),
                    label: 'Quiz',
                    activeIcon:
                        Assets.images.quiz.svg(color: AppColors.usualBlue)),
                BottomNavigationBarItem(
                    icon: Assets.images.profile
                        .svg(color: AppColors.usualBlue.withOpacity(0.3)),
                    label: 'Profile',
                    activeIcon:
                        Assets.images.profile.svg(color: AppColors.usualBlue)),
                BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Assets.images.settings.svg(
                        color: AppColors.usualBlue.withOpacity(0.3),
                        width: 24.w,
                        height: 24.h),
                    activeIcon: Assets.images.settings.svg(
                        color: AppColors.usualBlue, width: 24.w, height: 24.h)),
              ],
              backgroundColor: AppColors.darkblue,
              unselectedLabelStyle: TextStyle(
                fontFamily: 'MontBold',
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A66FFB2).withOpacity(0.3),
                fontSize: 12.h,
              ),
              currentIndex: 0,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.darkblue,
                  AppColors.darkblue,
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 160.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 67.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.yellow,
                            size: 57.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Icon(
                              Icons.star_rounded,
                              color: AppColors.yellow,
                              size: 57.h,
                            ),
                          ),
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.yellow,
                            size: 57.h,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Your result:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.w,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'MontBold'),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      '${widget.result}/${widget.indexOfQuiz * 10}'
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 96.w,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'MontBold'),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 88.w, right: 88.w, bottom: 96.h),
                      child: InkWell(
                        onTap: () async {
                          final box = await Hive.openBox<HiveResult>('results');
                          if (box.values
                              .where((element) =>
                                  element.quizIndex ==
                                  widget.indexOfQuiz.toString())
                              .isNotEmpty) {
                            box.values
                                .firstWhere((element) =>
                                    element.quizIndex ==
                                    widget.indexOfQuiz.toString())
                                .delete();
                          }
                          await box.add(HiveResult(
                              quizIndex: widget.indexOfQuiz.toString(),
                              correctAnswers: widget.result.toString()));
                          await box.close();
                          final stat = await Hive.openBox<ProfileStat>('profile');
                          if (stat.values.isEmpty == true)
                            stat.put(
                              'profile',
                              ProfileStat(
                                  totalCorrAnsw: 0,
                                  progress: 0,
                                  qQuiz: 0,
                                  eQuiz: 0,
                                  expQuiz: 0,
                                  hQuiz: 0,
                                  nQuiz: 0),
                            );
                          ProfileStat userData = stat.values.first;
                          if (userData.totalCorrAnsw != null) {
                            userData.totalCorrAnsw =
                                (userData.totalCorrAnsw! + widget.result);
                          } else {
                            userData.totalCorrAnsw = 0;
                            userData.totalCorrAnsw =
                                (userData.totalCorrAnsw! + widget.result);
                          }
                          switch (widget.indexOfQuiz) {
                            case 1:
                              (userData.qQuiz = userData.qQuiz! + 1);
                              break;
                            case 2:
                              (userData.eQuiz = userData.eQuiz! + 1);
                              break;
                            case 3:
                              (userData.nQuiz = userData.nQuiz! + 1);
                              break;
                            case 4:
                              (userData.hQuiz = userData.hQuiz! + 1);
                              break;
                            case 5:
                              (userData.expQuiz = userData.expQuiz! + 1);
                          }
                          if(userData.progress == null ) userData.progress=0;
                          userData.progress=((userData.totalCorrAnsw ?? 0)/ 150) as double?;
                          await stat.delete('profile');
                          await stat.put('profile', userData);
                          Navigator.popAndPushNamed(
                              context, MainNavigationRoutes.main);
                        },
                        child: Container(
                          height: 50.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColors.usualBlue),
                          child: Center(
                            child: Text(
                              'BACK'.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'MontBold',
                                fontSize: 22.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
