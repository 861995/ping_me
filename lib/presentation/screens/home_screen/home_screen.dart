import 'package:animation_list/animation_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:we_chat/helpers/toast_helper/toast_helper.dart';
import 'package:we_chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_state.dart';
import 'package:we_chat/presentation/utils/app_colors.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../../../helpers/page_navigate_animator/slide_page_navigator.dart';
import '../../bloc/home_screen/home_screen_event.dart';
import '../../widgets/drawer/drawer_widget.dart';
import '../../widgets/home_screen_widget/app_bar_widget.dart';
import '../chat_screen/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
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
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
              if (state is UsersLoaded) {
                List<Map<String, dynamic>> _filteredUsers =
                    state.users.where((user) {
                  return user['uid'] != currentUserId;
                }).toList();
                return AnimationList(
                  duration: 1500,
                  reBounceDepth: 10.0,
                  children: _filteredUsers.map((user) {
                    return _buildTile(
                        user['displayName'] ?? "",
                        user["photoURL"] ?? "",
                        context,
                        user['uid'] ?? "",
                        currentUserId);
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
      ),
    );
  }

  Widget _buildTile(String title, String? photoURL, BuildContext context,
      String recieverId, String currentUserId) {
    return InkWell(
      onTap: () {
        navigateToChatScreen(
            context, title, photoURL!, recieverId, currentUserId);
      },
      child: Container(
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
            Hero(
              tag: "profileImage${photoURL}",
              child: Container(
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
      ),
    );
  }

  void navigateToChatScreen(BuildContext context, String title, String photoURL,
      String receiverId, String currentUserId) async {
    final chatScreenBloc = BlocProvider.of<ChatScreenBloc>(context);
    final String chatId =
        await chatScreenBloc.getOrCreateChatId(currentUserId, receiverId);
    print(chatId);

    Navigator.push(
      context,
      SlidePageRoute(
          page: ChatScreen(
              chatId: chatId,
              userTitle: title,
              photoURL: photoURL,
              recieverId: receiverId,
              currentUserID: currentUserId)),
    );
  }
}
