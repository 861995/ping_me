import 'package:flutter/material.dart';
import 'package:we_chat/presentation/utils/app_const_text.dart';

import '../../../helpers/toast_helper/toast_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationIcon;
  final Gradient? gradient;

  const AppBarWidget(
      {super.key,
      this.title = AppConst.ping_me,
      this.showNotificationIcon = true,
      this.gradient});
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
      leading: Builder(builder: (context) {
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
}
