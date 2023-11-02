import 'dart:developer';

import 'package:edpal_music_app_ui/apihelper/music_handler.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


final logger = Logger(
  level: Level.warning, // Set the log level to WARNING or ERROR
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final isLoggedIn = await checkLoginStatus();
  await JustAudioBackground.init(
    // androidNotificationChannelId: 'com.ryanheise.audioservice.AudioService',
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: false,
  );

  runApp(MyApp(isLoggedIn: isLoggedIn));
  WidgetsBinding.instance.addObserver(Handler());
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: AppColors.backgroundColor,)),
        useMaterial3: true,
      ),
      home: isLoggedIn ? MainScreen() : const InitialLoginScreen(),
    );
  }
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String authToken = prefs.getString('token') ?? '';

  if (kDebugMode) {
    print('Login $isLoggedIn');
    log('Login Token $authToken');
  }
  return isLoggedIn;
}
