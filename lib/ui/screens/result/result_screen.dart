import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/data/app_settings/navigation/routes.dart';
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
        child: Dialog(
          backgroundColor: Color(0x041537E5).withOpacity(0),
            child:Container(
          color: Color(0x041537E5).withOpacity(0),
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
                        left: 50.w, right: 50.w, bottom: 96.h),
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
                                qQuiz: 0,
                                eQuiz: 0,
                                expQuiz: 0,
                                hQuiz: 0,
                                nQuiz: 0),
                          );
                        ProfileStat userData = stat.values.first;
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
                        await stat.delete('profile');
                        await stat.put('profile', userData);
                        Navigator.popAndPushNamed(
                            context, MainNavigationRoutes.main);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.usualBlue),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w,vertical: 12.h),
                          child: Center(
                            child: Text(
                              'back'.toUpperCase(),
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
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
        onWillPop: () async => false);
  }
}
