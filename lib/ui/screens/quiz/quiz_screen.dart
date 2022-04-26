import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/gen/assets.gen.dart';
import 'package:quiz_bet/main.dart';
import 'package:quiz_bet/ui/screens/home/models/quiz_model.dart';
import 'package:quiz_bet/ui/uikit/b_winners_label.dart';

import '../result/result_screen.dart';

enum Answered { correct, wrong, notStated }

class QuizScreen extends StatefulWidget {
  QuizScreen({required this.quiz, required this.indexOfQuiz});

  final int indexOfQuiz;
  final List<Quiz> quiz;

  @override
  State<StatefulWidget> createState() {
    return _QuizScreenState();
  }
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  int correctAnswers = 0;
  bool isCorrect = false;
  int isChosen = 0;
  bool fiftyFiftyEnable = true;
  Answered answered = Answered.notStated;
  List<bool> visible = List.generate(4, (index) => true);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      floatingActionButton: premium&&fiftyFiftyEnable
          ? Padding(
        padding: EdgeInsets.only(bottom: 107.h),
        child: InkWell(
          onTap: () {
            setState(() {
              visible.clear();
              visible.addAll(_fiftyFifty());
              fiftyFiftyEnable=false;
            });
          },
          child: Container(
            height: 56.h,
            width: 200.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: AppColors.yellow),
            child: Center(
              child: Text(
                '50/50'.toUpperCase(),
                style: TextStyle(
                  color: AppColors.darkblue,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserat',
                  fontSize: 20.w,
                ),
              ),
            ),
          ),
        ),
      )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                activeIcon: Assets.images.quiz.svg(color: AppColors.usualBlue)),
            BottomNavigationBarItem(
                icon: Assets.images.profile.svg(color: AppColors.usualBlue.withOpacity(0.3)),
                label: 'Profile',
                activeIcon: Assets.images.profile.svg(color: AppColors.usualBlue)),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                BWinLabel(),
                Divider(
                  color: AppColors.white.withOpacity(0.3),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                  child: Text(
                    widget.quiz[index].question!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20.w,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'MontBold'),
                  ),
                ),
                Wrap(
                  children: [
                    for (int i = 0; i < widget.quiz[index].answers!.length; i++)
                      Visibility(
                          visible: visible[i] == true,
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.usualBlue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color:borderColorSelector(isChosen)[i],width: 2.2.w)
                                ),
                                child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  onTap: () => answered == Answered.notStated
                                      ? _onAnswerPressed(i)
                                      : null,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20.r)),
                                      width: 145.w,
                                      height: 105.h,
                                      child: Center(
                                        child: Text(
                                          widget.quiz[index].answers![i]
                                              .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: textColorSelector(
                                                  isChosen)[i],
                                              fontSize: 22.w,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'MontBold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ), onWillPop: ()async=>false);
  }

  List<Color> textColorSelector(int chosenAnswIndex) {
    List<Color> colors = List.generate(4, (index) => AppColors.white);
    if (answered != Answered.notStated) {
      for (int i = 0; i < colors.length; i++) {
        if (i == chosenAnswIndex) {
          if (widget.quiz[index].answers![chosenAnswIndex] ==
              widget.quiz[index].correct) {
            colors[chosenAnswIndex] = AppColors.green;
          } else {
            colors[chosenAnswIndex] = AppColors.red;
          }
          colors[widget.quiz[index].answers!.indexWhere(
                  (element) => element == widget.quiz[index].correct)] =
              AppColors.green;
        }
      }
    }
    return colors;
  }

  List<Color> borderColorSelector(int chosenAnswIndex) {
    List<Color> colors = List.generate(4, (index) => AppColors.usualBlue);
    if (answered != Answered.notStated) {
      for (int i = 0; i < colors.length; i++) {
        if (i == chosenAnswIndex) {
          if (widget.quiz[index].answers![chosenAnswIndex] ==
              widget.quiz[index].correct) {
            colors[chosenAnswIndex] = AppColors.green;
          } else {
            colors[chosenAnswIndex] = AppColors.red;
          }
          colors[widget.quiz[index].answers!.indexWhere(
                  (element) => element == widget.quiz[index].correct)] =
              AppColors.green;
        }
      }
    }
    return colors;
  }

  List<bool> _fiftyFifty() {
    List<int> indexes = List.empty(growable: true);
    int correct = widget.quiz[index].answers!
        .indexWhere((element) => element == widget.quiz[index].correct);
    print('correct $correct');
    List<bool> list = List.generate(4, (index) => true);
    if (answered == Answered.notStated&&fiftyFiftyEnable) {
      while (indexes.contains(correct) || indexes.length < 2) {
        int test = Random().nextInt(4);
        if (test != correct && !indexes.contains(test)) indexes.add(test);
      }
      list[indexes.first] = false;
      list[indexes.last] = false;
      print(indexes);
      print(list);
    }
    return list;
  }

  void _onAnswerPressed(int i) {
    isChosen = i;
    print(widget.quiz[index].correct == widget.quiz[index].answers![i]);
    if (widget.quiz[index].correct == widget.quiz[index].answers![i]) {
      if (correctAnswers < 5) correctAnswers++;
      setState(() {
        answered = Answered.correct;
      });
    } else {
      setState(() {
        answered = Answered.wrong;
      });
    }
    if (index < widget.quiz.length - 1)
      Future.delayed(Duration(seconds: 2)).then((value) {
        setState(() {
          index++;
          answered = Answered.notStated;
          fiftyFiftyEnable=true;
          visible = List.generate(4, (index) => true);
        });
      });
    else {
      Future.delayed(Duration(seconds: 2)).then((value) => showDialog(context: context, builder: (_)=>ResultScreen(
        indexOfQuiz: widget.indexOfQuiz,
        result: correctAnswers,
      )));
    }
  }
}
