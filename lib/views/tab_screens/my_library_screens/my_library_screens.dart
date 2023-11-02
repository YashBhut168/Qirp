// import 'dart:io';

import 'dart:developer';

import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/without_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/download_screen/download_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/edit_profile_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/favorite_screen/favorite_song_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/playlist_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/queue_screen/queue_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<MyLibraryScreen> {
  ProfileController profileController = Get.put(ProfileController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  final TextEditingController countrycode = TextEditingController();
  bool isLoding = false;
  bool isLoggedIn = false;
  String? token;

  @override
  void initState() {
    super.initState();

    // sharedPref();
    SharedPreferences.getInstance().then((prefs) {
      bool login = prefs.getBool('isLoggedIn') ?? false;
      setState(() {
        isLoggedIn = login;
      });
    });
    log("${GlobVar.login}", name: 'library login');
    countrycode.text = "+91";
    // if (mounted) {
    //   setState(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.fetchProfile();
    });
    // profileController.fetchProfile();
    // setState(() {
    //   controller.isMiniPlayerOpenQueueSongs.value == true ||
    //           controller.isMiniPlayerOpenDownloadSongs.value == true ||
    //           controller.isMiniPlayerOpen.value == true ||
    //           controller.isMiniPlayerOpenHome1.value == true ||
    //           controller.isMiniPlayerOpenHome2.value == true ||
    //           controller.isMiniPlayerOpenHome3.value == true ||
    //           controller.isMiniPlayerOpenAllSongs.value == true
    //       ? controller.audioPlayer.play()
    //       : null;
    //   controller.currentListTileIndexQueueSongs.value;
    //   controller.currentListTileIndexDownloadSongs.value;
    //   controller.currentListTileIndex.value;
    //   controller.currentListTileIndexAllSongs.value;
    //   controller.currentListTileIndexCategory1.value;
    //   controller.currentListTileIndexCategory2.value;
    //   controller.currentListTileIndexCategory3.value;
    // });
    log("${controller.isMiniPlayerOpenQueueSongs.value}",
        name: "isMiniPlayerOpenQueueSongs");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
        name: "isMiniPlayerOpenDownloadSongs");
    log("${controller.isMiniPlayerOpen.value}", name: "isMiniPlayerOpen");
    log("${controller.isMiniPlayerOpenHome1.value}",
        name: "isMiniPlayerOpenHome1");
    log("${controller.isMiniPlayerOpenHome2.value}",
        name: "isMiniPlayerOpenHome2");
    log("${controller.isMiniPlayerOpenHome3.value}",
        name: "isMiniPlayerOpenHome3");

    log("${controller.queueSongsUrl}", name: "queueSongsUrl");
    log("${controller.isMiniPlayerOpenDownloadSongs.value}",
        name: "isMiniPlayerOpenDownloadSongs");

    //   });
    // }
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 10) {
      return phoneNumber;
    }

    String lastFourDigits = phoneNumber.substring(phoneNumber.length - 4);

    String maskedPhoneNumber = '+XXXXXXXX$lastFourDigits';

    return maskedPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: Padding(
              padding: const EdgeInsets.only(left: 7),
              child: lable(
                text: AppStrings.myLibrary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            automaticallyImplyLeading: false,
            centerTitle: false,
            actions: [
              commonIconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () async {
                  controller.audioPlayer.stop();
                  final prefs = await SharedPreferences.getInstance();
                  // ignore: unused_local_variable
                  final login = prefs.getBool('isLoggedIn');
                  GlobVar.login = false;
                  await prefs.setString('imagePath', '');
                  await prefs.setString('token', '');
                  await prefs.setBool('isLoggedIn', false);
                  var loginType = prefs.getString('loginType');
                  if (kDebugMode) {
                    print(loginType);
                  }
                  if (loginType == AppStrings.googleLogin) {
                    await GoogleSignIn().disconnect();
                    FirebaseAuth.instance.signOut();
                    await prefs.setString('loginType', '');
                  } else {}
                  snackBar('Logout successfully');
                  Get.offAll(const InitialLoginScreen());
                },
              ),
              sizeBoxWidth(15),
            ],
          ),
          body: Obx(
            () {
              var phoneNumber = profileController.mobile_no;
              var encryptPhonnumber = formatPhoneNumber(phoneNumber.value);
              if (profileController.isLoading.value == true) {
                return Center(
                  heightFactor: 14,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                );
              } else {
                return Column(
                  children: [
                    sizeBoxHeight(22),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                      child: Row(
                        children: [
                          containerIcon(
                            icon: Icons.person_2_outlined,
                            borderRadius: 20,
                            height: 35,
                            width: 35,
                            containerColor: Colors.grey,
                          ),
                          sizeBoxWidth(12),
                          GlobVar.login == true
                              ? Obx(
                                  () => lable(
                                    text:
                                        profileController.email.value.isNotEmpty
                                            ? profileController.email.value
                                            : encryptPhonnumber,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    lable(
                                      text: 'Guest',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    lable(
                                      text: 'Not logged in',
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ],
                                ),
                          const Spacer(),
                          GlobVar.login == true
                              ? TextButton(
                                  onPressed: () {
                                    Get.to(
                                      EditProfileScreen(
                                        encryptPhonnumber: encryptPhonnumber,
                                      ),
                                    );
                                  },
                                  child: lable(
                                    text: 'Edit',
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    sizeBoxHeight(20),
                    commonListTile(
                      icon: Icons.music_note_outlined,
                      text: 'Songs',
                    ),
                    commonListTile(
                      icon: Icons.album_outlined,
                      text: 'Albums',
                    ),
                    commonListTile(
                      icon: Icons.mic_external_on_outlined,
                      text: 'Artist',
                    ),
                    commonListTile(
                      onTap: () {
                        GlobVar.login == true
                            ? Get.to(const DownloadScreen())
                            : Get.to(
                                const WitoutLogginScreen(),
                                transition: Transition.downToUp,
                              );
                      },
                      icon: Icons.download,
                      text: 'Downloads',
                    ),
                    commonListTile(
                      onTap: () {
                        GlobVar.login == true
                            ? Get.to(const QueueSongsScreen())
                            : Get.to(
                                const WitoutLogginScreen(),
                                transition: Transition.downToUp,
                              );
                      },
                      icon: Icons.queue_music,
                      text: 'Queue Songs',
                    ),
                    commonListTile(
                      onTap: () {
                        GlobVar.login == true
                            ? Get.to(const FavoriteSongsScreen())
                            : Get.to(
                                const WitoutLogginScreen(),
                                transition: Transition.downToUp,
                              );
                      },
                      icon: Icons.favorite_border_outlined,
                      text: 'Favorite',
                    ),
                    commonListTile(
                      onTap: () {
                        GlobVar.login == true
                            ? Get.to(const PlylistScreen())
                            : Get.to(
                                const WitoutLogginScreen(),
                                transition: Transition.downToUp,
                              );
                        // Navigator.pushNamed(context, '/playlist');
                      },
                      icon: Icons.queue_music_outlined,
                      text: 'Playlists',
                    ),
                    commonListTile(
                      icon: Icons.videocam_outlined,
                      text: 'Videos',
                    ),
                  ],
                );
              }
            },
          )
          // : isLoding == true && isLoggedIn == false
          //     ? Center(
          //         child: CircularProgressIndicator(
          //         color: AppColors.white,
          //       ))
          //     : Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image.asset(
          //                 AppAsstes.appIconTeal,
          //                 height: 40,
          //               ),
          //               sizeBoxWidth(3),
          //               lable(
          //                 text: AppStrings.edpal,
          //                 fontSize: 25,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ],
          //           ),
          //           sizeBoxHeight(65),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 13, vertical: 13),
          //             child: lable(
          //                 text: AppStrings.loginAndEnjoyMoreThen80MillonSongs,
          //                 color: Colors.grey.shade600,
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w600),
          //           ),
          //           sizeBoxHeight(15),
          //           InkWell(
          //             onTap: () {
          //               Get.offAll(
          //                 const MobileLoginScreen(),
          //                 transition: Transition.downToUp,
          //               );
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 13),
          //               child: Container(
          //                 height: 50,
          //                 decoration: BoxDecoration(
          //                   color: AppColors.white,
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 child: Row(
          //                   children: [
          //                     const SizedBox(
          //                       width: 10,
          //                     ),
          //                     SizedBox(
          //                       width: 43,
          //                       child: TextField(
          //                         maxLength: 4,
          //                         keyboardType: TextInputType.phone,
          //                         controller: countrycode,
          //                         enabled: false,
          //                         style: const TextStyle(
          //                             fontSize: 18, color: Colors.grey),
          //                         decoration: const InputDecoration(
          //                           border: InputBorder.none,
          //                           counterText: "",
          //                         ),
          //                       ),
          //                     ),
          //                     sizeBoxWidth(15),
          //                     const Expanded(
          //                       child: TextField(
          //                         maxLength: 10,
          //                         keyboardType: TextInputType.phone,
          //                         enabled: false,
          //                         style: TextStyle(fontSize: 18),
          //                         decoration: InputDecoration(
          //                           hintText: "Continue with phone number",
          //                           counterText: "",
          //                           hintStyle: TextStyle(
          //                             color: Colors.grey,
          //                             fontWeight: FontWeight.normal,
          //                             fontSize: 16,
          //                           ),
          //                           border: InputBorder.none,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //           sizeBoxHeight(50),
          //           Row(
          //             children: [
          //               Expanded(
          //                 child: Divider(
          //                   height: 3,
          //                   color: Colors.grey.shade600,
          //                 ),
          //               ),
          //               lable(
          //                 text: '  Or  ',
          //                 color: Colors.grey.shade400,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //               Expanded(
          //                   child: Divider(
          //                 height: 3,
          //                 color: Colors.grey.shade600,
          //               )),
          //             ],
          //           ),
          //           sizeBoxHeight(40),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               containerIcon(
          //                 onTap: () {
          //                   googleSignIn();
          //                 },
          //                 image: Image.asset(
          //                   AppAsstes.google,
          //                   height: 45,
          //                 ),
          //                 border: Border.all(color: Colors.orange),
          //                 containerColor: AppColors.backgroundColor,
          //                 iconColor: AppColors.white,
          //                 height: 70,
          //                 width: 70,
          //                 borderRadius: 35,
          //               ),
          //               containerIcon(
          //                 onTap: () {
          //                   Get.offAll(const LogInScreen());
          //                 },
          //                 icon: Icons.mail_outline_outlined,
          //                 iconSize: 35,
          //                 border: Border.all(color: Colors.white),
          //                 containerColor: AppColors.backgroundColor,
          //                 iconColor: AppColors.white,
          //                 height: 70,
          //                 width: 70,
          //                 borderRadius: 35,
          //               )
          //             ],
          //           ),
          //         ],
          //       ),
          ),
    );
  }

  Widget commonListTile({
    required IconData icon,
    required String text,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: const Color(0xFF30343d),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColors.white,
          ),
          title: lable(text: text),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 15,
          ),
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
        Get.offAll(MainScreen());
        setState(() {
          isLoding = false;
        });
        snackBar('Login Succesfully');
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
