// import 'package:edpal_music_app_ui/main.dart';
import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> myKey1 = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizeBoxHeight(60),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppAsstes.appIconTeal,
                      scale: 7.5,
                    ),
                  ),
                  sizeBoxHeight(60),
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
                      key: myKey1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            sizeBoxHeight(43),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: lable(
                                  text: AppStrings.signUpC,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.45),
                            ),
                            sizeBoxHeight(45),
                            commonTextField(
                              hintText: AppStrings.fullName,
                              controller: fullNameController,
                              backgroundColor: const Color(0xFF141414),
                              borderColor: const Color(0xFF141414),
                              focusBorderColor: const Color(0xFF005FF7),
                              cursorColor: Colors.grey,
                              lableColor: Colors.grey,
                              onChanged: (p0) {
                                setState(() {});
                              },
                              validator: (value) =>
                                  AppValidation.validateName(value!),
                            ),
                            sizeBoxHeight(15),
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
                            sizeBoxHeight(20),
                            InkWell(
                              onTap: () async {
                                if (emailController.text != '' &&
                                    passwordController.text != '' &&
                                    fullNameController.text != '') {
                                  if (myKey1.currentState!.validate()) {
                                    authController
                                        .registerUser(
                                      userName: fullNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                        .then((value) {
                                      controller.currentIndex.value = 0;
                                      snackBar(AppStrings.registerSuccessfully);
                                      Get.offAll(MainScreen());
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
                                              passwordController.text == '' ||
                                              fullNameController.text == '')
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
                                              text: AppStrings.signUpS,
                                              color:
                                                  // phoneNumber.text == '' &&
                                                  emailController.text == '' ||
                                                          passwordController
                                                                  .text ==
                                                              '' ||
                                                          fullNameController
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
                                                          '' ||
                                                      fullNameController.text ==
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
                  // lable(
                  //     text: AppStrings.signUpC,
                  //     fontSize: 23,
                  //     fontWeight: FontWeight.w600,
                  //     letterSpacing: 0.45),
                  // SizedBox(
                  //   height: h * 0.09,
                  // ),
                  // commonTextField(
                  //   hintText: AppStrings.fullName,
                  //   controller: fullNameController,
                  //   validator: (value) => AppValidation.validateName(value!),
                  // ),
                  // sizeBoxHeight(15),
                  // commonTextField(
                  //   hintText: AppStrings.email,
                  //   controller: emailController,
                  //   validator: (value) => AppValidation.validateEmail(value!),
                  // ),
                  // sizeBoxHeight(15),
                  // commonTextField(
                  //   hintText: AppStrings.password,
                  //   controller: passwordController,
                  //   validator: (value) =>
                  //       AppValidation.validatePassword(value!),
                  //   notShowText: true,
                  // ),
                  // sizeBoxHeight(20),
                  // Obx(
                  //   () => authController.isLoading.value == true
                  //       ? Align(
                  //           alignment: Alignment.center,
                  //           child: CircularProgressIndicator(
                  //             color: AppColors.white,
                  //           ),
                  //         )
                  //       : Align(
                  //           alignment: Alignment.center,
                  //           child: customElevatedButton(
                  //             text: AppStrings.signUpS,
                  //             onPressed: () {
                  //               if (myKey1.currentState!.validate()) {
                  //                 authController
                  //                     .registerUser(
                  //                   userName: fullNameController.text,
                  //                   email: emailController.text,
                  //                   password: passwordController.text,
                  //                 )
                  //                     .then((value) {
                  //                   controller.currentIndex.value = 0;
                  //                   snackBar(AppStrings.registerSuccessfully);
                  //                   Get.offAll(MainScreen());
                  //                 });
                  //               }
                  //             },
                  //           ),
                  //         ),
                  // ),
                  sizeBoxHeight(140),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      lable(
                          text: AppStrings.alreadyHaveAnAccount, fontSize: 15),
                      InkWell(
                        onTap: () {
                          Get.to(const LogInScreen());
                        },
                        child: const Text(
                          AppStrings.signIn,
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
