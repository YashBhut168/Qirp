import 'dart:async';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpMobileAuthScreen extends StatefulWidget {
  final String? varify;
  final TextEditingController? phoneNumber;
  final TextEditingController? email;
  final CountryCode? selectedCountry;
  final String inWhichScreen;

  const OtpMobileAuthScreen(
      {this.varify,
      this.phoneNumber,
      this.email,
      this.selectedCountry,
      required this.inWhichScreen,
      super.key});

  @override
  State<OtpMobileAuthScreen> createState() => _OtpMobileAuthScreenState();
}

class _OtpMobileAuthScreenState extends State<OtpMobileAuthScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthController authController = Get.put(AuthController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  // ProfileController profileController = Get.put(ProfileController());

  var code = '';
  bool isLoding = false;
  late Timer _resendTimer;
  int _remainingTime = 30;
  bool showResendButton = true;

  void startResendTimer() {
    _remainingTime = 30; // Reset the countdown time to 30 seconds
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _resendTimer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.themeBlueColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final submittedPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.themeBlueColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
              size: 26,
            ),
            onPressed: () {
              widget.inWhichScreen == AppStrings.initScreen
                  ? Get.offAll(const InitialLoginScreen())
                  : Get.off(const LogInScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                sizeBoxHeight(20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: lable(
                    text: AppStrings.sixDigitOtpSent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                sizeBoxHeight(12),
                Row(
                  children: [
                    lable(
                        text: widget.inWhichScreen == AppStrings.initScreen
                            ? "${widget.selectedCountry!.dialCode ?? ''} ${widget.phoneNumber!.text}"
                            : widget.email!.text),
                  ],
                ),
                sizeBoxHeight(100),
                Pinput(
                  length: 6,
                  showCursor: true,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onChanged: (value) {
                    if (kDebugMode) {
                      print('val::::::$value');
                    }

                    code = value;
                    log(code, name: 'otp');
                    setState(() {});
                  },
                ),
                sizeBoxHeight(50),
                InkWell(
                  onTap: () async {
                    if (showResendButton) {
                      startResendTimer();
                      widget.inWhichScreen == AppStrings.initScreen
                          ? resendOtp()
                          : resendOtpEmail();
                    }
                  },
                  child: lable(
                    text: _remainingTime > 0 && showResendButton
                        ? 'Resend OTP in 00:$_remainingTime'
                        : AppStrings.resendOtp,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                sizeBoxHeight(360),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoding = true;
                    });

                    widget.inWhichScreen == AppStrings.initScreen
                        ? verifyOtp()
                        : verifyOtpEmail();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 13,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: code == ''
                          ? const Color(0xFF262626)
                          : const Color(0xFF005FF7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: isLoding == true
                        ? Center(
                            heightFactor: 0.8,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                        : lable(
                            text: AppStrings.next,
                            color: code == ''
                                ? const Color(0xFF605F5F)
                                : AppColors.white,
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  verifyOtp() async {
    try {
      // timeout:
      const Duration(seconds: 20);
      var credential = PhoneAuthProvider.credential(
        verificationId: widget.varify!,
        smsCode: code.toString(),
        //  pinController.toString(),
      );

      if (kDebugMode) {
        print('code:$code');
      }
      if (kDebugMode) {
        print('OTP PAGE VARIFI::::${widget.varify}');
      }

      await auth.signInWithCredential(credential);
      if (kDebugMode) {
        print(widget.phoneNumber!.text);
      }
      authController
          .registerUser(
              mobileNo:
                  '${widget.selectedCountry!.dialCode}${widget.phoneNumber!.text}')
          .then(
            (value) => snackBar(AppStrings.loginSuccessfully),
          )
          .then((value) {
        controller.isMiniPlayerOpenQueueSongs.value = false;
        controller.isMiniPlayerOpenDownloadSongs.value = false;
        controller.isMiniPlayerOpen.value = false;
        controller.isMiniPlayerOpenAllSongs.value = false;
        controller.isMiniPlayerOpenAlbumSongs.value = false;
        controller.isMiniPlayerOpenArtistSongs.value = false;
        controller.isMiniPlayerOpenHome.value = false;
        controller.isMiniPlayerOpenFavoriteSongs.value = false;
        controller.isMiniPlayerOpenSearchSongs.value = false;
        controller.isMiniPlayerOpenAdminPlaylistSongs.value = false;
        Get.offAll(MainScreen(), transition: Transition.upToDown);
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      controller.currentIndex.value = 0;
      GlobVar.login = true;
      // log("${GlobVar.login}", name: 'library login');
      // profileController.fetchProfile();
      // controller.fetchData();
      // Future.delayed(const Duration(seconds: 5)).then((value) =>
      // );

      setState(() {
        isLoding = false;
      });
    } catch (e) {
      snackBar('$e', title: 'Error');
      setState(() {
        isLoding = false;
      });
      if (kDebugMode) {
        print('error:: $e');
      }
    }
  }

  verifyOtpEmail() async {
    authController
        .verifyOtpUser(
      email: widget.email!.text,
      otp: code,
    )
        .then((value) {
      if (GlobVar.verifyOtpApiSuccess == true) {
        controller.currentIndex.value = 0;
        snackBar(GlobVar.forgotPasswordApiMessage);
        setState(() {
          isLoding = false;
        });
        controller.isMiniPlayerOpenQueueSongs.value = false;
        controller.isMiniPlayerOpenDownloadSongs.value = false;
        controller.isMiniPlayerOpen.value = false;
        controller.isMiniPlayerOpenAllSongs.value = false;
        controller.isMiniPlayerOpenAlbumSongs.value = false;
        controller.isMiniPlayerOpenArtistSongs.value = false;
        controller.isMiniPlayerOpenHome.value = false;
        controller.isMiniPlayerOpenFavoriteSongs.value = false;
        controller.isMiniPlayerOpenSearchSongs.value = false;
        controller.isMiniPlayerOpenAdminPlaylistSongs.value = false;
        Get.offAll(
          MainScreen(),
          transition: Transition.upToDown,
        );
      } else {
        snackBar(GlobVar.forgotPasswordApiMessage);
        setState(() {
          isLoding = false;
        });
      }
    });
  }

  resendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            '${widget.selectedCountry!.dialCode}${widget.phoneNumber!.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        timeout: const Duration(seconds: 20),
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoding = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          MobileLoginScreen.verify = verificationId;
          if (kDebugMode) {
            print('OTP PAGE VARIFI::::$verificationId');
          }
          snackBar('OTP sent Succesfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      snackBar('$e', title: 'Error');
      setState(() {
        isLoding = false;
      });
    }
  }

  resendOtpEmail() {
    authController
        .forgotPassword(
      email: widget.email!.text,
    )
        .then((value) {
      if (GlobVar.forgotPasswordApiSuccess == true) {
        //   controller.currentIndex.value = 0;
        snackBar(GlobVar.forgotPasswordApiMessage);
        setState(() {
          isLoding = false;
        });
        // Get.offAll(OtpMobileAuthScreen(
        //   inWhichScreen: AppStrings.forgotScreen,
        //   email: widget.email!.text,
        // ));
      } else {
        snackBar(GlobVar.forgotPasswordApiMessage);
        setState(() {
          isLoding = false;
        });
      }
    });
  }
}
