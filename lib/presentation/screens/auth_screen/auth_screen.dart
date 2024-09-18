import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:we_chat/helpers/toast_helper/toast_helper.dart';
import 'package:we_chat/presentation/bloc/auth/auth_bloc.dart';
import 'package:we_chat/presentation/bloc/auth/auth_state.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_const_text.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';
import '../../bloc/auth/auth_event.dart';
import '../../widgets/auth/auth_text_field_widget.dart';
import '../home_screen/home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      duration: Durations.medium4,
      reverseDuration: Durations.medium4,
      overlayWidgetBuilder: (state) {
        return Center(
          child: LoadingAnimationWidget.flickr(
              //
              size: 50.sp,
              leftDotColor: AppColors.kPrimaryColor,
              rightDotColor: AppColors.kTertiaryColor),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is Authenticated) {
            showToast("Logged in Successfully");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        }, builder: (context, state) {
          if (state is AuthLoading) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/login.jpeg",
                    height: 350.sp,
                    width: 400.sp,
                  ),
                  _buildWelcomeText(),
                  buildEmptySpace(10.sp),
                  AuthTextFieldWidget(
                    hintText: AppConst.enter_email,
                    controller: _emailController,
                  ),
                  buildEmptySpace(20.sp),
                  AuthTextFieldWidget(
                    hintText: AppConst.enter_pass,
                    controller: _passwordController,
                  ),
                  buildEmptySpace(20.sp),
                  _buildLoginButton(),
                  buildEmptySpace(20.sp),
                  _buildSocialPlatformLogin(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedButton(
      onPress: () {
        context.read<AuthBloc>().add(
              SignInWithEmail(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
        // showToast("Logged In");
      },
      height: 45.h,
      width: 150.w,
      text: AppConst.login,
      isReverse: false,
      selectedTextColor: AppColors.kPrimaryColor,
      transitionType: TransitionType.BOTTOM_CENTER_ROUNDER,
      animationDuration: const Duration(milliseconds: 500),
      textStyle: AppFonts.bold20.copyWith(color: AppColors.kWhiteColor),
      backgroundColor: AppColors.kPrimaryColor,
      borderColor: AppColors.kPrimaryColor,
      borderRadius: 50,
      borderWidth: 2,
    );
  }

  Widget _buildSocialPlatformLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(),
        _buildIndividualLogin(Brands.gmail, () {
          context.read<AuthBloc>().add(SignInWithGoogle());
        }),
        _buildIndividualLogin(Brands.facebook, () {
          showToast(AppConst.in_next_build);
        }),
        _buildIndividualLogin(Brands.linkedin, () {
          showToast(AppConst.in_next_build);
        }),
        _buildIndividualLogin(Brands.apple_logo, () {
          showToast(AppConst.in_next_build);
        }),
        const SizedBox(),
      ],
    );
  }

  Widget _buildIndividualLogin(
    String logo,
    void Function() onCall,
  ) {
    return InkWell(
      onTap: onCall,
      child: Brand(logo),
    );
  }

  Widget _buildWelcomeText() {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(seconds: 1)),
        ScaleEffect(duration: Duration(seconds: 1)),
      ],
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          AppConst.welcome_to_ping_me,
          style: AppFonts.bold20.copyWith(color: Colors.white, fontSize: 30.sp),
        ),
      ),
    );
  }

  Widget buildEmptySpace(double space) {
    return SizedBox(height: space);
  }
}
