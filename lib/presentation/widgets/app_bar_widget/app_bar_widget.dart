import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_state.dart';
import 'package:we_chat/presentation/screens/profile_pic_view_screen/profile_pic_view_screen.dart';
import 'package:we_chat/presentation/utils/app_const_text.dart';

import '../../../helpers/toast_helper/toast_helper.dart';
import '../../bloc/home_screen/home_screen_event.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import 'package:intl/intl.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationIcon;
  final Gradient? gradient;
  final bool? isBackNeeded;
  final bool? isProfileImage;
  final String? photoURL;
  final String? recieverId;

  const AppBarWidget(
      {super.key,
      this.title = AppConst.ping_me,
      this.showNotificationIcon = true,
      this.gradient,
      this.isBackNeeded = false,
      this.isProfileImage = false,
      this.photoURL,
      this.recieverId});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            title,
            style: AppFonts.bold20.copyWith(color: AppColors.kWhiteColor),
          ),
          recieverId != null
              ? BlocProvider(
                  create: (context) =>
                      HomeScreenBloc()..add(FetchUserStatus(recieverId!)),
                  child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                    builder: (context, state) {
                      if (state is UserStatusLoaded) {
                        return state.isOnline
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 15.sp,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "online",
                                    style: AppFonts.regular14
                                        .copyWith(color: AppColors.kWhiteColor),
                                  ),
                                ],
                              )
                            : Text(
                                "Last seen at ${DateFormat.jm().format(state.lastSeen)}", // Formats to "4:30 PM"
                                style: AppFonts.regular14
                                    .copyWith(color: AppColors.kWhiteColor),
                              );
                      } else if (state is UserStatusError) {
                        return Center(child: Text('offline'));
                      }
                      return const Center(child: Text('offline'));
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
      centerTitle: true,
      elevation: 2.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      leading: isBackNeeded == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25.sp,
                    )),
              ],
            )
          : Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
      actions: [
        if (showNotificationIcon)
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.kWhiteColor,
            ),
            onPressed: () {
              showToast("Notification Screen under Construction");
            },
          ),
        isProfileImage == true
            ? InkWell(
                onTap: () {
                  navigateToProfileViewScreen(context, photoURL!);
                },
                child: Hero(
                  tag: "profileImage${photoURL}",
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: photoURL != null && photoURL!.isNotEmpty
                            ? NetworkImage(photoURL!)
                            : const AssetImage(
                                    "assets/images/no_profile_image.jpeg")
                                as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient ??
              LinearGradient(
                colors: [Colors.purple.shade100, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        ),
      ),
    );
  }

  void navigateToProfileViewScreen(
    BuildContext context,
    String photoURL,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePicViewScreen(
                photoURL: photoURL,
              )),
    );
  }
}
