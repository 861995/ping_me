import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicViewScreen extends StatelessWidget {
  final String photoURL;
  const ProfilePicViewScreen({super.key, required this.photoURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Hero(
                tag: "profileImage$photoURL",
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : const AssetImage(
                                  "assets/images/no_profile_image.jpeg")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
