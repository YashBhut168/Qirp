import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/otp_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> myKey5 = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                sizeBoxHeight(10),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 26,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      sizeBoxHeight(60),
                      Image.asset(
                        AppAsstes.qirpLogo,
                        scale: 7.5,
                      ),
                      // lable(
                      //     text: AppStrings.qirp,
                      //     fontSize: 33,
                      //     fontWeight: FontWeight.w800,
                      //     letterSpacing: 1.9),
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
                    key: myKey5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          sizeBoxHeight(43),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: lable(
                              text: AppStrings.sendOtpToEmail,
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
                          sizeBoxHeight(18),
                          InkWell(
                            onTap: () async {
                              if (emailController.text != '') {
                                if (myKey5.currentState!.validate()) {
                                  authController
                                      .forgotPassword(
                                    email: emailController.text,
                                  )
                                      .then((value) {
                                    if (GlobVar.forgotPasswordApiSuccess == true) {
                                    //   controller.currentIndex.value = 0;
                                    snackBar(GlobVar.forgotPasswordApiMessage);
                                    Get.offAll(OtpMobileAuthScreen(
                                      inWhichScreen: AppStrings.forgotScreen,
                                      email: emailController,
                                    ));
                                    } else {
                                      snackBar(GlobVar.forgotPasswordApiMessage);
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
                                    (emailController.text == '')
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
                                            text: 'Continue',
                                            color:
                                                // phoneNumber.text == '' &&
                                                emailController.text == ''
                                                    ? const Color(0xFF605F5F)
                                                    : AppColors.white,
                                            textAlign: TextAlign.center,
                                          ),
                                          // sizeBoxWidth(12),
                                          // Icon(
                                          //   Icons.login,
                                          //   size: 24.0,
                                          //   color: emailController.text == ''
                                          //       ? const Color(0xFF605F5F)
                                          //       : AppColors.white,
                                          // ),
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
              ],
            ),
          ),
        )),
      ),
    );
  }
}
