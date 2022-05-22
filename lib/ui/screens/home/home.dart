import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/main.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';
import 'package:quiz_bet/ui/screens/onboarding/ui/onboarding_screen.dart';
import 'package:quiz_bet/ui/screens/quiz/models/limit_model/limit_model.dart';
import 'package:quiz_bet/ui/screens/quiz/quiz_screen.dart';
import 'package:quiz_bet/ui/uikit/xbet_label.dart';
import 'package:quiz_bet/ui/uikit/rounded_button.dart';
import 'models/quiz_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Iterable<HiveResult> results = [];
  LimitsHive limits = LimitsHive();
  List<String> labels = ['', 'quick', 'easy', 'normal', 'hard', 'expert'];
  Future<bool> loadHive() async {
    final box = await Hive.openBox<LimitsHive>('limits');
    if (box.isEmpty == true)
      box.put('limits', LimitsHive(timeToUpdate: DateTime.now(), attempts: 5));
    limits = box.values.first;
    await Hive.openBox<HiveResult>('results')
        .then((value) => results = value.values);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var data = '';
    rootBundle.loadString('assets/quizes.json').then((value) => data = value);
    loadHive().then((value) => setState(() {}));
    return FutureBuilder(
        future: loadHive(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF041B47),
                      Color(0xFF031434),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      BWinLabel(),
                      Divider(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                      if (!subscribed)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.r),
                                    border: Border.all(
                                        color: AppColors.red, width: 2.2)),
                                child: Center(
                                    child: Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.red,
                                )),
                              ),
                              SizedBox(
                                width: 18.w,
                              ),
                              Text(
                                'You have ${limits.attempts} attempts left',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'MontBold',
                                    fontSize: 16.w,
                                    color: AppColors.red),
                              )
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          children: [
                            Wrap(
                              children: [
                                for (int i = 1; i < 6; i++)
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: RoundedRectangleBtn(
                                        label: (i * 10).toString() +
                                            '\n ' +
                                            labels[i].toUpperCase() +
                                            ' QUIZ',
                                        onTap: () => _onTap(i, data),
                                        result: results
                                                .where((element) =>
                                                    element.quizIndex ==
                                                    i.toString())
                                                .isNotEmpty
                                            ? results.firstWhere((element) =>
                                                element.quizIndex ==
                                                i.toString())
                                            : null,
                                      ))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              height: double.infinity,
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
            );
          }
        });
  }

  Future<void> _onTap(int index, dynamic data) async {
    final box = await Hive.openBox<LimitsHive>('limits');
    final datad = box.values.first;
    if (datad.timeToUpdate!.difference(DateTime.now()).inHours > 23) {
      datad.timeToUpdate = DateTime.now();
      datad.attempts = 5;
    }
    final listMapAll = jsonDecode(data);
    List<Quiz> quiz = [];
    for (int i = 0; i < listMapAll[index - 1][index.toString()].length; i++)
      quiz.add(Quiz.fromJson(listMapAll[index - 1][index.toString()][i]));
    if (subscribed == true ||  ((datad.attempts!) > 0)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext ctx) =>
              QuizScreen(quiz: quiz, indexOfQuiz: index),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext ctx) => OnBoardingScreen(),
        ),
      );
    }
    if (datad.attempts! > 0) datad.attempts = (box.values.first.attempts!) - 1;
    await box.clear();
    await box.put('limits', datad);
  }
}
