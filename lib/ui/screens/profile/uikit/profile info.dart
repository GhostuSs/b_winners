import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/data/app_settings/color_pallete/colors.dart';

class ProfileInfo extends StatelessWidget{
  ProfileInfo({required this.info, required this.stat});
  final String info;
  final String stat;
  @override
  Widget build(BuildContext context)=>Text.rich(TextSpan(
      text: info,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16.h,
        fontFamily: 'MontBold',
        color: AppColors.usualBlue,
      ),
      children: [TextSpan(
        text: stat,
        style:  TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.h,
          fontFamily: 'MontBold',
          color: AppColors.white,
        ),
      )
      ]
  ));

}