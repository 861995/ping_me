import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/domain/repository/user_local_repository.dart';
import 'package:we_chat/presentation/bloc/auth/auth_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'package:we_chat/presentation/bloc/home_screen/home_screen_event.dart';
import 'package:we_chat/presentation/screens/home_screen/home_screen.dart';
import 'package:we_chat/presentation/screens/on_board_screen/on_board_screen.dart';

import 'core/injection/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeScreenBloc>(
              create: (context) => HomeScreenBloc()..add(FetchUsersStream()),
            ),
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                FirebaseAuth.instance,
                GoogleSignIn(),
                getIt<UserLocalRepository>(),
                BlocProvider.of<HomeScreenBloc>(context),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Login App',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Builder(builder: (context) {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              return FutureBuilder<Map<String, dynamic>?>(
                future: authBloc.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return const HomeScreen();
                  } else {
                    return const OnBoardScreen();
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }
}
