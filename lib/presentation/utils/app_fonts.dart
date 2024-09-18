import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppFonts {
  static final boldFont = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15.sp,
    color: AppColors.kPrimaryColor,
  );

  static final regularFont = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: AppColors.kPrimaryColor,
  );

  static final regular12 = regularFont.copyWith(fontSize: 12.sp);
  static final regular14 = regularFont.copyWith(fontSize: 14.sp);
  static final regular18 = regularFont.copyWith(fontSize: 18.sp);

  static final bold18 = boldFont.copyWith(fontSize: 18.sp);
  static final bold20 = boldFont.copyWith(fontSize: 20.sp);
}
