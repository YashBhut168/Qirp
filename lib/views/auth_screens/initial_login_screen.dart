import 'dart:developer';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialLoginScreen extends StatefulWidget {
  const InitialLoginScreen({super.key});

  @override
  State<InitialLoginScreen> createState() => _InitialLoginScreenState();
}

class _InitialLoginScreenState extends State<InitialLoginScreen> {
  final TextEditingController countrycode = TextEditingController();
  AuthController authController = Get.put(AuthController());
  // ignore: unused_field
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    countrycode.text = "+91";
  }

  bool isLoding = false;

  List<String> imageList = [
    AppAsstes.initialMusicBackground,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: isLoding == true
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.white,
              ))
            : Stack(
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        items: imageList.map((imagePath) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.fill,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 1,
                          aspectRatio: 20 / 24,
                          autoPlayInterval: const Duration(seconds: 3),
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaY: 10,
                              sigmaX: 10,
                              // sigmaX: 0.1,
                              // sigmaY: 0.1,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.backgroundColor,
                                    AppColors.backgroundColor.withOpacity(0.9),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                // color: AppColors.backgroundColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.550,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.backgroundColor.withOpacity(0.9),
                                AppColors.backgroundColor.withOpacity(0.4)
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
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            await prefs.setString('token', '');
                            Get.offAll(MainScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    lable(
                                      text: AppStrings.skip,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: AppColors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        sizeBoxHeight(100),
                        sizeBoxHeight(100),
                        sizeBoxHeight(100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAsstes.appIconTeal,
                              height: 40,
                            ),
                            sizeBoxWidth(3),
                            lable(
                              text: AppStrings.edpal,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        sizeBoxHeight(55),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 13),
                          child: lable(
                            text: AppStrings.loginAndEnjoyMoreThen80MillonSongs,
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        sizeBoxHeight(10),
                        InkWell(
                          onTap: () {
                            Get.to(
                              const MobileLoginScreen(),
                              transition: Transition.downToUp,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 43,
                                    child: TextField(
                                      maxLength: 4,
                                      keyboardType: TextInputType.phone,
                                      controller: countrycode,
                                      enabled: false,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  sizeBoxWidth(15),
                                  const Expanded(
                                    child: TextField(
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      enabled: false,
                                      style: TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        hintText: "Continue with phone number",
                                        counterText: "",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        sizeBoxHeight(50),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 3,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            lable(
                              text: '  Or  ',
                              color: Colors.grey.shade400,
                            ),
                            Expanded(
                                child: Divider(
                              height: 3,
                              color: Colors.grey.shade600,
                            )),
                          ],
                        ),
                        sizeBoxHeight(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            containerIcon(
                              onTap: () {
                                googleSignIn();
                              },
                              image: Image.asset(
                                AppAsstes.google,
                                height: 30,
                              ),
                              border: Border.all(color: Colors.orange),
                              containerColor: AppColors.backgroundColor,
                              iconColor: AppColors.white,
                              height: 50,
                              width: 50,
                            ),
                            containerIcon(
                              onTap: () {
                                Get.to(const LogInScreen());
                              },
                              icon: Icons.mail_outline_outlined,
                              border: Border.all(color: Colors.white),
                              containerColor: AppColors.backgroundColor,
                              iconColor: AppColors.white,
                              height: 50,
                              width: 50,
                            )
                          ],
                        ),
                        sizeBoxHeight(30),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              lable(
                                text: 'By continuing, you agree to our',
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Terms',
                                      style: TextStyle(
                                        fontSize: 11,
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey.shade600,
                                        decorationColor: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                        text: ' & ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        )),
                                    TextSpan(
                                      text: 'Privacy Policy.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey.shade600,
                                        decorationColor: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        sizeBoxHeight(30),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  googleSignIn() async {
    setState(() {
      isLoding = true;
    });
    if (kDebugMode) {
      print("googleLogin method Called");
    }
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var reslut = await googleSignIn.signIn();
      if (reslut == null) {
        setState(() {
          isLoding = false;
        });
        return;
      } else {
        log(reslut.email);
        log((reslut.displayName)!);
        if (reslut.displayName != '' && reslut.email != '') {
          authController
              .socialLoginUser(
            email: reslut.email,
            userName: (reslut.displayName)!,
            loginType: AppStrings.googleLogin,
          )
              .then((value) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('loginType', AppStrings.googleLogin);
            snackBar(AppStrings.loginSuccessfully);
            Get.offAll(MainScreen());
          });
        } else {
          if (kDebugMode) {
            print('enter valid user');
          }
        }
        // Get.offAll(MainScreen());
        // setState(() {
        //   isLoding = false;
        // });
        // snackBar('Login Succesfully');
      }
    } catch (error) {
      setState(() {
        isLoding = false;
      });
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
