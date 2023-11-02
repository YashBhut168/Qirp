import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/sign_up_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  GlobalKey<FormState> myKey2 = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: AppColors.backgroundColor,
        //   automaticallyImplyLeading: true,
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: AppColors.white,
        //       size: 26,
        //     ),
        //     onPressed: () {
        //       Get.offAll(const InitialLoginScreen());
        //     },
        //   ),
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeBoxHeight(10),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      Get.offAll(const InitialLoginScreen());
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        sizeBoxHeight(60),
                        Image.asset(
                          AppAsstes.appIconTeal,
                          scale: 7.5,
                        ),
                        lable(
                            text: AppStrings.edpal,
                            fontSize: 33,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.9),
                      ],
                    ),
                  ),
                  sizeBoxHeight(45),
                  Card(
                    elevation: 1,
                    color: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(
                        color: Color(0xFF2B2B2B),
                      ),
                    ),
                    child: Form(
                      key: myKey2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            sizeBoxHeight(43),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: lable(
                                text: AppStrings.loginC,
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                              ),
                            ),
                            sizeBoxHeight(45),
                            commonTextField(
                              hintText: AppStrings.email,
                              controller: emailController,
                              backgroundColor: const Color(0xFF141414),
                              borderColor: const Color(0xFF141414),
                              focusBorderColor: const Color(0xFF005FF7),
                              cursorColor: Colors.grey,
                              lableColor: Colors.grey,
                              onChanged: (p0) {
                                setState(() {});
                              },
                              validator: (value) =>
                                  AppValidation.validateEmail(value!),
                            ),
                            sizeBoxHeight(15),
                            commonTextField(
                              hintText: AppStrings.password,
                              controller: passwordController,
                              backgroundColor: const Color(0xFF141414),
                              borderColor: const Color(0xFF141414),
                              focusBorderColor: const Color(0xFF005FF7),
                              cursorColor: Colors.grey,
                              lableColor: Colors.grey,
                              onChanged: (p0) {
                                setState(() {});
                              },
                              validator: (value) =>
                                  AppValidation.validatePassword(value!),
                              notShowText: true,
                            ),
                            sizeBoxHeight(18),
                            InkWell(
                              onTap: () async {
                                if (emailController.text != '' &&
                                    passwordController.text != '') {
                                  if (myKey2.currentState!.validate()) {
                                    authController
                                        .loginUser(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                        .then((value) {
                                      if (GlobVar.login == true) {
                                        controller.currentIndex.value = 0;
                                        snackBar(AppStrings.loginSuccessfully);
                                        Get.offAll(MainScreen());
                                      } else {
                                        snackBar('Unauthorised User');
                                      }
                                    });
                                  } else {
                                    if (kDebugMode) {
                                      print('enter valid user');
                                    }
                                  }
                                } else {
                                  null;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 13,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      //  phoneNumber.text == '' &&
                                      (emailController.text == '' ||
                                              passwordController.text == '')
                                          ? const Color(0xFF262626)
                                          : const Color(0xFF005FF7),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Obx(
                                  () => authController.isLoading.value == true
                                      ? Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            lable(
                                              text: 'Login',
                                              color:
                                                  // phoneNumber.text == '' &&
                                                  emailController.text == '' ||
                                                          passwordController
                                                                  .text ==
                                                              ''
                                                      ? const Color(0xFF605F5F)
                                                      : AppColors.white,
                                              textAlign: TextAlign.center,
                                            ),
                                            sizeBoxWidth(12),
                                            Icon(
                                              Icons.login,
                                              size: 24.0,
                                              color: emailController.text ==
                                                          '' ||
                                                      passwordController.text ==
                                                          ''
                                                  ? const Color(0xFF605F5F)
                                                  : AppColors.white,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            sizeBoxHeight(63),
                          ],
                        ),
                      ),
                    ),
                  ),
                  sizeBoxHeight(15),
                  // lable(
                  //   text: AppStrings.loginC,
                  //   fontWeight: FontWeight.w700,
                  //   fontSize: 23,
                  // ),
                  // sizeBoxHeight(45),
                  // commonTextField(
                  //   hintText: AppStrings.email,
                  //   controller: emailController,
                  //   backgroundColor: const Color(0xFF141414),
                  //   borderColor: const Color(0xFF141414),
                  //   validator: (value) => AppValidation.validateEmail(value!),
                  // ),
                  // sizeBoxHeight(15),
                  // commonTextField(
                  //   hintText: AppStrings.password,
                  //   controller: passwordController,
                  //   backgroundColor: const Color(0xFF141414),
                  //   borderColor: const Color(0xFF141414),
                  //   validator: (value) =>
                  //       AppValidation.validatePassword(value!),
                  //   notShowText: true,
                  // ),
                  // sizeBoxHeight(15),
                  // Obx(
                  //   () => authController.isLoading.value == true
                  //       ? Align(
                  //           alignment: Alignment.center,
                  //           child: CircularProgressIndicator(
                  //             color: AppColors.white,
                  //           ),
                  //         )
                  //       :
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        lable(text: AppStrings.forgotPassword),
                        sizeBoxHeight(20),
                        // customElevatedButton(
                        //   text: AppStrings.loginS,
                        //   onPressed: () async {
                        //     if (myKey2.currentState!.validate()) {
                        //       authController
                        //           .loginUser(
                        //         email: emailController.text,
                        //         password: passwordController.text,
                        //       )
                        //           .then((value) {
                        //         if (GlobVar.login == true) {
                        //           controller.currentIndex.value = 0;
                        //           snackBar(
                        //               AppStrings.loginSuccessfully);
                        //           Get.offAll(MainScreen());
                        //         } else {
                        //           snackBar('Unauthorised User');
                        //         }
                        //       });
                        //     } else {
                        //       if (kDebugMode) {
                        //         print('enter valid user');
                        //       }
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  // ),
                  sizeBoxHeight(70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      lable(text: AppStrings.createNewAccountTo, fontSize: 15),
                      InkWell(
                        onTap: () {
                          Get.to(const SignUpScreen());
                        },
                        child: const Text(
                          AppStrings.signUpM,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
