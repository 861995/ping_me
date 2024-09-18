import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../auth_screen/auth_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to We Chat",
          body: "Welcome to the app! This is a description of how it works.",
          image: Center(
            child: Icon(
              HeroIcons.chat_bubble_oval_left_ellipsis,
              color: AppColors.kPrimaryColor,
              size: 350.sp,
            ),
          ),
          decoration: PageDecoration(
            imageFlex: 2,
            titleTextStyle: AppFonts.bold20,
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
            titleTextStyle: AppFonts.bold20,
            bodyTextStyle: AppFonts.regular14,
          ),
        ),
        PageViewModel(
          title: "Chat Securely",
          body: "Chat with your friends and also secure your chat",
          image: Center(
            child: Icon(
              Iconsax.security_bold,
              color: Colors.black,
              size: 350.sp,
            ),
          ),
          decoration: PageDecoration(
            imageFlex: 2,
            titleTextStyle: AppFonts.bold20,
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
