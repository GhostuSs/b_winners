import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/app_settings/color_pallete/colors.dart';

class BWinLabel extends StatelessWidget {
  const BWinLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 46.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'B',
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'MontBold',
                fontSize: 36.h),
          ),
          SizedBox(width: 10.w,),
          Text(
            'WINNERS',
            style: TextStyle(
                color: AppColors.usualBlue,
                fontWeight: FontWeight.w700,
                fontFamily: 'MontBold',
                fontSize: 36.h),
          )
        ],
      ),
    );
  }
}
