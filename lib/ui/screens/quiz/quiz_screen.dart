import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/gen/assets.gen.dart';
import 'package:quiz_bet/main.dart';
import 'package:quiz_bet/ui/screens/home/models/quiz_model.dart';
import 'package:quiz_bet/ui/uikit/xbet_label.dart';

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
  Answered answered = Answered.notStated;
  List<bool> visible = List.generate(4, (index) => true);
  late Widget label;
  late Timer _timer;
  int _start = 15;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          label = _start==15/*&&subscribed==false*/ ? Text('-1 attempt',
              style: TextStyle(
                color: AppColors.red,
                fontFamily: 'MontBold',
                fontWeight: FontWeight.w700,
                fontSize: 16.w,
              )) : Text('');
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    label = subscribed==false ? Text('-1 attempt',
        style: TextStyle(
          color: AppColors.red,
          fontFamily: 'MontBold',
          fontWeight: FontWeight.w700,
          fontSize: 16.w,
        )) : Text('');
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(children: [
        Scaffold(
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
          floatingActionButton: Padding(
            child: label,
            padding: EdgeInsets.only(bottom: 94.h),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Container(
            color: AppColors.darkblue,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding:EdgeInsets.only(top: 45.h,right: 55.w),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Center(child: Icon(Icons.arrow_back_ios,color: AppColors.white,),),
                            ),
                          ),
                        ),
                        BWinLabel()
                      ],
                    ),
                    Divider(
                      color: AppColors.white.withOpacity(0.3),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.red,
                            size: 24.w,
                          ),
                          SizedBox(
                            width: 18.w,
                          ),
                          Text(
                            '${_start} seconds left',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'MontBold',
                                fontSize: 16.w,
                                color: AppColors.red),
                          )
                        ],
                      ),
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
                        for (int i = 0;
                            i < widget.quiz[index].answers!.length;
                            i++)
                          Visibility(
                            visible: visible[i] == true,
                            child: Padding(
                              padding: EdgeInsets.all(5.w),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.usualBlue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                        color: borderColorSelector(isChosen)[i],
                                        width: 2.2.w)),
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
                                              fontSize: 20.w,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'MontBold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _start == 0,
          child: ResultScreen(
            result: correctAnswers,
            indexOfQuiz: widget.indexOfQuiz,
          ),
        )
      ]),
      onWillPop: () async => false,
    );
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

  void _onAnswerPressed(int i) {
    isChosen = i;
    print(widget.quiz[index].correct == widget.quiz[index].answers![i]);
    if (widget.quiz[index].correct == widget.quiz[index].answers![i]) {
      if (correctAnswers < 5) correctAnswers++;
      _start += 10;
      setState(() {
        answered = Answered.correct;
        label = Text(
          '+10 seconds',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 16.w,
            fontFamily: 'MontBold',
            fontWeight: FontWeight.w700,
          ),
        );
      });
    } else {
      setState(() {
        label = Text('');
        answered = Answered.wrong;
      });
    }
    if (index < widget.quiz.length - 1)
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        setState(() {
          index++;
          answered = Answered.notStated;
          label=Text('');
          visible = List.generate(4, (index) => true);
        });
      });
    else {
      _timer.cancel();
      Future.delayed(Duration(milliseconds: 500)).then((value) => showDialog(
            context: context,
            builder: (_) => Scaffold(
              backgroundColor: Color(0x041537E5),
              body: ResultScreen(
                indexOfQuiz: widget.indexOfQuiz,
                result: correctAnswers,
              ),
            ),
          ));
    }
  }
}
