import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mymanage/auth/auth.dart';
import 'package:mymanage/firebase_options.dart';
import 'package:mymanage/api_helper/notiapi.dart';
import 'package:mymanage/socail/bloc/social_bloc.dart';
import 'package:mymanage/socail/pages/social_page.dart';
import 'package:mymanage/socail/repo/firebase_social_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Noti.initializeNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialBloc(SocialService()),
          child: const SocialPage(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Colors.white,
            secondary: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
      ),
    );
  }
}
