import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../../utils/app_const_text.dart';
import '../auth_screen/auth_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.purple.shade50,
      pages: [
        PageViewModel(
          title: AppConst.welcome_to_ping_me,
          body: "Welcome to the app! This is a description of how it works.",
          image: Center(
            child: Icon(
              FontAwesome.p_solid,
              size: 400.sp,
              color: AppColors.kPrimaryColor,
            ),
          ),
          decoration: PageDecoration(
            imageFlex: 2,
            titleTextStyle: AppFonts.bold20.copyWith(color: Colors.black),
            bodyTextStyle: AppFonts.regular14,
          ),
        ),
        PageViewModel(
          title: "Social Media Login",
          body:
              "You can login using your Gmail, Facebook, LinkedIn, Apple account",
          image: Center(
            child: Brand(
              Brands.gmail,
              size: 400.sp,
            ),
          ),
          decoration: PageDecoration(
            imageFlex: 2,
            titleTextStyle: AppFonts.bold20.copyWith(color: Colors.black),
            bodyTextStyle: AppFonts.regular14,
          ),
        ),
        PageViewModel(
          title: "Chat Securely",
          body: "Chat with your friends and also secure your chat",
          image: Center(
            child: Icon(
              IonIcons.finger_print,
              size: 300.sp,
              color: AppColors.kPrimaryColor,
            ),
          ),
          decoration: PageDecoration(
            imageFlex: 2,
            titleTextStyle: AppFonts.bold20.copyWith(color: Colors.black),
            bodyTextStyle: AppFonts.regular14,
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Icon(Icons.skip_next, color: AppColors.kSecondaryColor),
      next: Text(
        "Next",
        style: AppFonts.boldFont,
      ),
      done: Text(
        "Done",
        style: AppFonts.bold20,
      ),
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
