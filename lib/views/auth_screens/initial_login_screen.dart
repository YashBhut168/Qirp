import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/otp_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialLoginScreen extends StatefulWidget {
  const InitialLoginScreen({super.key});

  static String verify = "";

  @override
  State<InitialLoginScreen> createState() => _InitialLoginScreenState();
}

class _InitialLoginScreenState extends State<InitialLoginScreen> {
  GlobalKey<FormState> myKeyInit = GlobalKey<FormState>();
  final TextEditingController countrycode = TextEditingController();
  AuthController authController = Get.put(AuthController());
  final TextEditingController phoneNumber = TextEditingController();
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));
  // ignore: deprecated_member_use
  CountryCode _selectedCountry = CountryCode.fromCode('IN');

  // ignore: unused_field, prefer_final_fields
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    countrycode.text = "+91";
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token){
      if (kDebugMode) {
        GlobVar.deviceToken = token!;
        print("Device token---> $token");
        print("Device token Glob---> ${GlobVar.deviceToken}");

      }
  });
  }

  @override
  void dispose() {
    phoneNumber.clear();
    super.dispose();
  }

  bool isLodingMobile = false;
  bool isLodingGmail = false;

  List<String> imageList = [
    AppAsstes.initialMusicBackground,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                sizeBoxHeight(64),
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.setString('token', '');
                    Get.offAll(MainScreen());
                  },
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
                sizeBoxHeight(40),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAsstes.qirpLogo,
                    height: 60,
                  ),
                ),
                sizeBoxHeight(45),
                Card(
                  elevation: 1,
                  color: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(color: Color(0xFF2B2B2B))),
                  child: Form(
                    key: myKeyInit,
                    child: Column(
                      children: [
                        sizeBoxHeight(43),
                        lable(
                          text: 'Continue with',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        sizeBoxHeight(22),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Card(
                                elevation: 0,
                                color: const Color(0xFF141414),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // decoration: const BoxDecoration(
                                //   borderRadius: BorderRadius.all(
                                //     Radius.circular(5),
                                //   ),
                                // ),
                                child: CountryCodePicker(
                                  onChanged: (CountryCode countryCode) {
                                    setState(() {
                                      _selectedCountry = countryCode;
                                    });
                                  },
                                  initialSelection: 'IN',
                                  textStyle:
                                      const TextStyle(color: Color(0xFF8e8e94)),
                                  showCountryOnly: false,
                                  showFlag: false,
                                  showOnlyCountryWhenClosed: false,
                                  searchStyle:
                                      const TextStyle(color: Colors.grey),
                                  searchDecoration: const InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.grey)),
                                  dialogTextStyle:
                                      const TextStyle(color: Colors.grey),
                                  showDropDownButton: false,
                                  dialogBackgroundColor: AppColors
                                      .backgroundColor
                                      .withOpacity(0.9),
                                  barrierColor: Colors.transparent,
                                  alignLeft: false,
                                ),
                              ),
                              sizeBoxWidth(11),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF141414),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: TextFormField(
                                    maxLength: 10,
                                    expands: false,
                                    keyboardType: TextInputType.phone,
                                    controller: phoneNumber,
                                    // autofocus: true,
                                    validator: (value) =>
                                        AppValidation.validatePhone(value!),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade400),
                                    cursorColor: Colors.grey.shade400,
                                    decoration:  InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 10,
                                      ),
                                      hintText: "Enter phone number",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.themeBlueColor,
                                        ), // Change border color when focused
                                      ),
                                      errorText: null,
                                      counterText: "",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeBoxHeight(18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: InkWell(
                            onTap: () async {
                              if (phoneNumber.text.length > 7) {
                                if (myKeyInit.currentState!.validate()) {
                                  setState(() {
                                    isLodingMobile = true;
                                  });
                                  sendOtp();
                                } else {
                                  snackBar('Enter valid mobile number');
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
                                    phoneNumber.text.length <= 7
                                        ? const Color(0xFF262626)
                                        : AppColors.themeBlueColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: isLodingMobile == true
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
                                  : lable(
                                      text: 'Continue',
                                      color:
                                          // phoneNumber.text == '' &&
                                          phoneNumber.text.length <= 7
                                              ? const Color(0xFF605F5F)
                                              : AppColors.white,
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                        sizeBoxHeight(31),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFF828282),
                                  height: 1,
                                ),
                              ),
                              lable(
                                text: ' OR ',
                                // ignore: prefer_const_constructors
                                color: Color(0xFF828282),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFF828282),
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeBoxHeight(29.5),
                        commonAuthContainer(
                            onTap: () {
                              Get.to(const LogInScreen());
                            },
                            image: AppAsstes.gmail,
                            text: 'Continue with Email'),
                        sizeBoxHeight(18),
                        commonAuthContainer(
                            image: AppAsstes.apple,
                            text: 'Continue with Apple'),
                        sizeBoxHeight(18),
                        commonAuthContainer(
                            onTap: () {
                              googleSignIn();
                            },
                            isLoading: isLodingGmail,
                            isIcon: true,
                            icon: Icons.g_mobiledata,
                            text: 'Continue with Gmail'),
                        sizeBoxHeight(63),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendOtp() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${_selectedCountry.dialCode}${phoneNumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        timeout: const Duration(seconds: 30),
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLodingMobile = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          InitialLoginScreen.verify = verificationId;
          if (kDebugMode) {
            print('PHONE PAGE VARIFI::::$verificationId');
          }
          snackBar('OTP sent Succesfully');
          setState(() {
            isLodingMobile = false;
          });

          Get.to(OtpMobileAuthScreen(
            phoneNumber: phoneNumber,
            selectedCountry: _selectedCountry,
            varify: verificationId,
            inWhichScreen: AppStrings.initScreen,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      snackBar('$e', title: 'Error');
      setState(() {
        isLodingMobile = false;
      });
    }
  }

  googleSignIn() async {
    setState(() {
      isLodingGmail = true;
    });
    if (kDebugMode) {
      print("googleLogin method Called");
    }
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var reslut = await googleSignIn.signIn();
      if (reslut == null) {
        setState(() {
          isLodingGmail = false;
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
            Get.offAll(MainScreen(), transition: Transition.upToDown);
            controller.currentIndex.value = 0;
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
        isLodingGmail = false;
      });
      if (kDebugMode) {
        print(error);
      }
    }
  }
}

// import 'dart:developer';
// import 'dart:ui';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:edpal_music_app_ui/controllers/auth_controller.dart';
// import 'package:edpal_music_app_ui/utils/assets.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/mobile_login_screen.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class InitialLoginScreen extends StatefulWidget {
//   const InitialLoginScreen({super.key});

//   @override
//   State<InitialLoginScreen> createState() => _InitialLoginScreenState();
// }

// class _InitialLoginScreenState extends State<InitialLoginScreen> {
//   final TextEditingController countrycode = TextEditingController();
//   AuthController authController = Get.put(AuthController());
//   // ignore: unused_field
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     countrycode.text = "+91";
//   }

//   bool isLoding = false;

//   List<String> imageList = [
//     AppAsstes.initialMusicBackground,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         body: isLoding == true
//             ? Center(
//                 child: CircularProgressIndicator(
//                 color: AppColors.white,
//               ))
//             : Stack(
//                 children: [
//                   Stack(
//                     children: [
//                       CarouselSlider(
//                         items: imageList.map((imagePath) {
//                           return SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height * 0.6,
//                             child: Image.asset(
//                               imagePath,
//                               fit: BoxFit.fill,
//                             ),
//                           );
//                         }).toList(),
//                         options: CarouselOptions(
//                           autoPlay: true,
//                           scrollDirection: Axis.horizontal,
//                           viewportFraction: 1,
//                           aspectRatio: 20 / 24,
//                           autoPlayInterval: const Duration(seconds: 3),
//                           enlargeCenterPage: true,
//                           onPageChanged: (index, reason) {
//                             setState(() {
//                               _currentIndex = index;
//                             });
//                           },
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         child: ClipRect(
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(
//                               sigmaY: 10,
//                               sigmaX: 10,
//                               // sigmaX: 0.1,
//                               // sigmaY: 0.1,
//                             ),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width,
//                               height:
//                                   MediaQuery.of(context).size.height * 0.025,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     AppColors.backgroundColor,
//                                     AppColors.backgroundColor.withOpacity(0.9),
//                                   ],
//                                   begin: Alignment.bottomCenter,
//                                   end: Alignment.topCenter,
//                                 ),
//                                 // color: AppColors.backgroundColor.withOpacity(0.8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height * 0.550,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.backgroundColor.withOpacity(0.9),
//                                 AppColors.backgroundColor.withOpacity(0.4)
//                               ],
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                             ),
//                             // color: AppColors.backgroundColor.withOpacity(0.6),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SafeArea(
//                     child: Column(
//                       children: [
//                         const Spacer(),
//                         InkWell(
//                           onTap: () async {
//                             final prefs = await SharedPreferences.getInstance();
//                             await prefs.setBool('isLoggedIn', false);
//                             await prefs.setString('token', '');
//                             Get.offAll(MainScreen());
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 13),
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width * 0.2,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 2, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black87.withOpacity(0.3),
//                                   borderRadius: const BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     lable(
//                                       text: AppStrings.skip,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     Icon(
//                                       Icons.chevron_right_outlined,
//                                       color: AppColors.white,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         sizeBoxHeight(100),
//                         sizeBoxHeight(100),
//                         sizeBoxHeight(100),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               AppAsstes.appIconTeal,
//                               height: 40,
//                             ),
//                             sizeBoxWidth(3),
//                             lable(
//                               text: AppStrings.edpal,
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ],
//                         ),
//                         sizeBoxHeight(55),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 13, vertical: 13),
//                           child: lable(
//                             text: AppStrings.loginAndEnjoyMoreThen80MillonSongs,
//                             color: Colors.grey.shade600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         sizeBoxHeight(10),
//                         InkWell(
//                           onTap: () {
//                             Get.to(
//                               const MobileLoginScreen(),
//                               transition: Transition.downToUp,
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 13),
//                             child: Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: AppColors.white,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   SizedBox(
//                                     width: 43,
//                                     child: TextField(
//                                       maxLength: 4,
//                                       keyboardType: TextInputType.phone,
//                                       controller: countrycode,
//                                       enabled: false,
//                                       style: const TextStyle(
//                                           fontSize: 18, color: Colors.grey),
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                         counterText: "",
//                                       ),
//                                     ),
//                                   ),
//                                   sizeBoxWidth(15),
//                                   const Expanded(
//                                     child: TextField(
//                                       maxLength: 10,
//                                       keyboardType: TextInputType.phone,
//                                       enabled: false,
//                                       style: TextStyle(fontSize: 18),
//                                       decoration: InputDecoration(
//                                         hintText: "Continue with phone number",
//                                         counterText: "",
//                                         hintStyle: TextStyle(
//                                           color: Colors.grey,
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: 16,
//                                         ),
//                                         border: InputBorder.none,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         sizeBoxHeight(50),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Divider(
//                                 height: 3,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                             lable(
//                               text: '  Or  ',
//                               color: Colors.grey.shade400,
//                             ),
//                             Expanded(
//                                 child: Divider(
//                               height: 3,
//                               color: Colors.grey.shade600,
//                             )),
//                           ],
//                         ),
//                         sizeBoxHeight(40),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             containerIcon(
//                               onTap: () {
//                                 googleSignIn();
//                               },
//                               image: Image.asset(
//                                 AppAsstes.google,
//                                 height: 30,
//                               ),
//                               border: Border.all(color: Colors.orange),
//                               containerColor: AppColors.backgroundColor,
//                               iconColor: AppColors.white,
//                               height: 50,
//                               width: 50,
//                             ),
//                             containerIcon(
//                               onTap: () {
//                                 Get.to(const LogInScreen());
//                               },
//                               icon: Icons.mail_outline_outlined,
//                               border: Border.all(color: Colors.white),
//                               containerColor: AppColors.backgroundColor,
//                               iconColor: AppColors.white,
//                               height: 50,
//                               width: 50,
//                             )
//                           ],
//                         ),
//                         sizeBoxHeight(30),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               lable(
//                                 text: 'By continuing, you agree to our',
//                                 color: Colors.grey.shade600,
//                                 fontSize: 12,
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'Terms',
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         decoration: TextDecoration.underline,
//                                         color: Colors.grey.shade600,
//                                         decorationColor: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                         text: ' & ',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey.shade600,
//                                         )),
//                                     TextSpan(
//                                       text: 'Privacy Policy.',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         decoration: TextDecoration.underline,
//                                         color: Colors.grey.shade600,
//                                         decorationColor: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                         sizeBoxHeight(30),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   googleSignIn() async {
//     setState(() {
//       isLoding = true;
//     });
//     if (kDebugMode) {
//       print("googleLogin method Called");
//     }
//     GoogleSignIn googleSignIn = GoogleSignIn();
//     try {
//       var reslut = await googleSignIn.signIn();
//       if (reslut == null) {
//         setState(() {
//           isLoding = false;
//         });
//         return;
//       } else {
//         log(reslut.email);
//         log((reslut.displayName)!);
//         if (reslut.displayName != '' && reslut.email != '') {
//           authController
//               .socialLoginUser(
//             email: reslut.email,
//             userName: (reslut.displayName)!,
//             loginType: AppStrings.googleLogin,
//           )
//               .then((value) async {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('loginType', AppStrings.googleLogin);
//             snackBar(AppStrings.loginSuccessfully);
//             Get.offAll(MainScreen());
//           });
//         } else {
//           if (kDebugMode) {
//             print('enter valid user');
//           }
//         }
//         // Get.offAll(MainScreen());
//         // setState(() {
//         //   isLoding = false;
//         // });
//         // snackBar('Login Succesfully');
//       }
//     } catch (error) {
//       setState(() {
//         isLoding = false;
//       });
//       if (kDebugMode) {
//         print(error);
//       }
//     }
//   }
// }
