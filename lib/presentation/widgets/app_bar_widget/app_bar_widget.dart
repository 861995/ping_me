import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_chat/presentation/screens/profile_pic_view_screen/profile_pic_view_screen.dart';
import 'package:we_chat/presentation/utils/app_const_text.dart';

import '../../../helpers/toast_helper/toast_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationIcon;
  final Gradient? gradient;
  final bool? isBackNeeded;
  final bool? isProfileImage;
  final String? photoURL;

  const AppBarWidget(
      {super.key,
      this.title = AppConst.ping_me,
      this.showNotificationIcon = true,
      this.gradient,
      this.isBackNeeded = false,
      this.isProfileImage = false,
      this.photoURL});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppFonts.bold20.copyWith(color: AppColors.kWhiteColor),
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