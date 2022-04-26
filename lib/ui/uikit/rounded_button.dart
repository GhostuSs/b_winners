import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz_bet/ui/screens/home/models/results/hive_results.dart';

import '../../data/app_settings/color_pallete/colors.dart';

class RoundedRectangleBtn extends StatelessWidget {
  const RoundedRectangleBtn(
      {Key? key, required this.label, required this.onTap, this.result})
      : super(key: key);
  final HiveResult? result;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.usualBlue,width: 2.2.w),
          borderRadius: BorderRadius.circular(20.h),
          color: AppColors.usualBlue.withOpacity(0.3),
        ),
        width: double.infinity,
        height: 105.h,
        child: Stack(
          children: [
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'MontBold',
                    fontSize: 24.w,
                    fontWeight: FontWeight.w400),
              ),
            ),
            if (result != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 19.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded,color: AppColors.yellow,size: 28.w,),
                      SizedBox(height: 6.h,),
                      Text(
                          result!.correctAnswers!,
                          style: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'MontBold',
                              fontSize: 16.w,
                              fontWeight: FontWeight.w400)
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
