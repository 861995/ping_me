import 'package:animation_list/animation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:we_chat/helpers/toast_helper/toast_helper.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_state.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/home_screen/home_screen_event.dart';
import '../../widgets/drawer/drawer_widget.dart';
import '../../widgets/home_screen_widget/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      backgroundColor: AppColors.kWhiteColor,
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          HeroIcons.archive_box,
        ),
        onPressed: () {
          showToast("Add Screen under Construction");
        },
      ),
      body: BlocProvider(
        create: (context) => HomeScreenBloc()..add(FetchUsersStream()),
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UsersLoaded) {
              return AnimationList(
                duration: 1500,
                reBounceDepth: 10.0,
                children: state.users.map((user) {
                  return _buildTile(
                      user['displayName'] ?? "", user["photoURL"] ?? "");
                }).toList(),
              );
            }
            if (state is NoUsersFound) {
              return const Center(child: Text("No User Found"));
            }
            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }

  Widget _buildTile(String title, String? photoURL) {
    return Container(
      height: 60.sp,
      margin: EdgeInsets.symmetric(vertical: 5.sp),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: AppColors.kPrimaryColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Container(
            width: 70.sp,
            height: 70.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: photoURL != null && photoURL.isNotEmpty
                    ? NetworkImage(photoURL)
                    : const AssetImage("assets/images/no_profile_image.jpeg")
                        as ImageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.sp, left: 10.sp),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppFonts.boldFont,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
