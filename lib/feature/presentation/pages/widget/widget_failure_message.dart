import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WidgetFailureMessage extends StatelessWidget {
  final String? errorTitle;
  final String? errorSubtitle;

  const WidgetFailureMessage({
    super.key,
    this.errorTitle,
    this.errorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          'assets/svg/undraw_newspaper.svg',
          width: ScreenUtil().screenWidth / 3,
          height: ScreenUtil().screenHeight / 3,
        ),
        SizedBox(height: 24.h),
        Text(
          errorTitle ?? "Something went wrong",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          errorSubtitle ??
              "Check your wi-fi connection or cellular data \nand try again.",
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
