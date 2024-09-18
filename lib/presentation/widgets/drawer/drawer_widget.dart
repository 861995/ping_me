import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_chat/helpers/toast_helper/toast_helper.dart';
import 'package:we_chat/presentation/bloc/auth/auth_event.dart';
import 'package:we_chat/presentation/screens/auth_screen/auth_screen.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../../bloc/auth/auth_bloc.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.kPrimaryColor,
            ),
            child: Builder(builder: (context) {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              return FutureBuilder<Map<String, dynamic>?>(
                future: authBloc.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    final userData = snapshot.data!;
                    final photoURL = userData['photoURL'];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70.sp,
                          height: 70.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: photoURL != null && photoURL.isNotEmpty
                                  ? NetworkImage(photoURL)
                                  : const AssetImage(
                                          "assets/images/no_profile_image.jpeg")
                                      as ImageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userData["displayName"] ?? "",
                              style: AppFonts.bold20
                                  .copyWith(color: AppColors.kWhiteColor),
                            ),
                            Text(
                              userData["email"] ?? "",
                              style: AppFonts.regular12
                                  .copyWith(color: AppColors.kWhiteColor),
                            )
                          ],
                        ),
                        SizedBox()
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Container(
                          width: 70.sp,
                          height: 70.sp,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/no_profile_image.jpeg"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }),
          ),
          const Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text("Sign Out"),
            onTap: () {
              context.read<AuthBloc>().add(SignOut());
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
                (Route<dynamic> route) => false,
              );
              showToast("Signed out");
            },
          ),
        ],
      ),
    );
  }
}
