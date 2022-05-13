import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';
import 'package:quiz_bet/ui/screens/profile/models/profile_model.dart';
import 'package:quiz_bet/ui/screens/profile/uikit/profile%20info.dart';
import 'package:quiz_bet/ui/uikit/xbet_label.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileStat stat=ProfileStat();
  int corrAnsw = 0;

  Future load()async{
    final box = await Hive.openBox<ProfileStat>('profile');
    final res = await Hive.openBox<HiveResult>('results');
    for(final el in res.values){
      print(el.correctAnswers);
      corrAnsw+=int.tryParse(el.correctAnswers!) ?? 0;
    }
    stat=box.values.first;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child: ProfileInfo(
                                info: 'Total number of correct answers: ',
                                stat: (corrAnsw).toString()),
                          ),
                          Divider(
                            color: AppColors.white.withOpacity(0.3),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child: ProfileInfo(
                                info: 'Progress: ', stat: ((corrAnsw/150*100).round()).toString() + '%'),
                          ),
                          Divider(
                            color: AppColors.white.withOpacity(0.3),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child:
                            ProfileInfo(info: 'Number of games played: ', stat: ''),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child:
                            ProfileInfo(info: '1. Quick Quiz: ', stat: stat.qQuiz.toString()),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child:
                            ProfileInfo(info: '2. Easy Quiz: ', stat:stat.eQuiz.toString()),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child: ProfileInfo(
                                info: '3. Normal Quiz: ', stat: stat.nQuiz.toString()),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child:
                            ProfileInfo(info: '4. Hard Quiz: ', stat: stat.hQuiz.toString()),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
                            child: ProfileInfo(
                                info: '5. Expert Quiz: ', stat: stat.expQuiz.toString()),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      }else{
        return Scaffold(
          backgroundColor: AppColors.darkblue,
        );
      }
    });
  }
}
