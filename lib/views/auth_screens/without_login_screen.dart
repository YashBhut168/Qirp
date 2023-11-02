import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WitoutLogginScreen extends StatefulWidget {
  const WitoutLogginScreen({super.key});

  @override
  State<WitoutLogginScreen> createState() => _WitoutLogginScreenState();
}

class _WitoutLogginScreenState extends State<WitoutLogginScreen> {
  MainScreenController controller = Get.put(MainScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Image.asset(
                  AppAsstes.loginImage,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.backgroundColor.withOpacity(1),
                        AppColors.backgroundColor.withOpacity(0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    // color: AppColors.backgroundColor.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: lable(
                  text: 'Sign in',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: lable(
                  text: 'to continue',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeBoxHeight(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                          controller.audioPlayer.stop();
                            Get.offAll(const InitialLoginScreen(),
                                transition: Transition.leftToRight);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            backgroundColor: const Color(0xFF005FF7),
                            elevation: 5,
                          ),
                          child: lable(
                            text: 'Sign up',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                    sizeBoxWidth(15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.audioPlayer.stop();
                          Get.offAll(const InitialLoginScreen(),
                              transition: Transition.leftToRight);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          backgroundColor: const Color(0xFFffffff),
                          elevation: 5,
                        ),
                        child: lable(
                          text: 'Log in',
                          color: const Color(0xFF040404),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sizeBoxHeight(35),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    controller.currentIndex.value = 0;
                    Get.offAll(
                      MainScreen(),
                      transition: Transition.upToDown,
                    );
                  },
                  child: Text(
                    'Continue without login',
                    style: TextStyle(
                      color: AppColors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              sizeBoxHeight(45),
            ],
          )
        ],
      ),
    );
  }
}
