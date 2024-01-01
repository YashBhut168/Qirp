// import 'dart:io';

import 'dart:developer';

import 'package:edpal_music_app_ui/controllers/main_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/controllers/queue_songs_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/globVar.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/without_login_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/admin_playlists/admin_playlist_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/album_screen/album_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/artist_screen/artist_screen.dart';
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
  QueueSongsScreenController queueSongsScreenController =
      Get.put(QueueSongsScreenController());

  bool isLoding = false;

  @override
  void initState() {
    super.initState();
    log("${GlobVar.login}", name: 'library login');
    profileController.fetchProfile();
    controller.isMiniPlayerOpenQueueSongs.value == true ||
            controller.isMiniPlayerOpenDownloadSongs.value == true ||
            controller.isMiniPlayerOpen.value == true ||
            controller.isMiniPlayerOpenAllSongs.value == true ||
            controller.isMiniPlayerOpenAlbumSongs.value == true ||
            controller.isMiniPlayerOpenArtistSongs.value == true ||
            controller.isMiniPlayerOpenHome.value == true ||
            controller.isMiniPlayerOpenFavoriteSongs.value == true ||
            controller.isMiniPlayerOpenSearchSongs.value == true ||
            controller.isMiniPlayerOpenAdminPlaylistSongs.value == true
        ? controller.audioPlayer.play()
        : controller.audioPlayer.stop();
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Obx(
          () {
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 40, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        lable(
                          text: AppStrings.myLibrary,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                        GlobVar.login == true
                            ? commonIconButton(
                                icon: const Icon(
                                  Icons.logout,
                                ),
                                onPressed: () async {
                                  controller.audioPlayer.stop();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  // ignore: unused_local_variable
                                  final login = prefs.getBool('isLoggedIn');
                                  GlobVar.login = false;
                                  await prefs.setString('imagePath', '');
                                  await prefs.setString('token', '');
                                  await prefs.setBool('isLoggedIn', false);
                                  var loginType = prefs.getString('loginType');
                                  GlobVar.userId = '';
                                  if (kDebugMode) {
                                    print(loginType);
                                  }
                                  if (loginType == AppStrings.googleLogin) {
                                    await GoogleSignIn().disconnect();
                                    FirebaseAuth.instance.signOut();
                                    await prefs.setString('loginType', '');
                                  } else {}
                                  snackBar('Logout successfully');
                                  Get.offAll(
                                    const InitialLoginScreen(),
                                    transition: Transition.downToUp,
                                  );
                                  controller.isMiniPlayerOpenQueueSongs.value =
                                      false;
                                  controller.isMiniPlayerOpenDownloadSongs
                                      .value = false;
                                  controller.isMiniPlayerOpen.value = false;
                                  controller.isMiniPlayerOpenAllSongs.value =
                                      false;
                                  controller.isMiniPlayerOpenAlbumSongs.value =
                                      false;
                                  controller.isMiniPlayerOpenArtistSongs.value =
                                      false;
                                  controller.isMiniPlayerOpenHome.value = false;
                                  controller.isMiniPlayerOpenFavoriteSongs
                                      .value = false;
                                  controller.isMiniPlayerOpenSearchSongs.value =
                                      false;
                                  controller.isMiniPlayerOpenAdminPlaylistSongs
                                      .value = false;
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  // sizeBoxWidth(15),

                  sizeBoxHeight(22),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        GlobVar.login == false
                            ? Get.to(
                                const WitoutLogginScreen(),
                                transition: Transition.downToUp,
                              )
                            : null;
                      },
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

                                        // profileController.profileModel!.profile!.email!.isNotEmpty ?
                                        //  profileController.profileModel!.profile!.email! :
                                        //  profileController.profileModel!.profile!.mobileNo!,
                                        // GlobVar.emailProfile.isNotEmpty ?
                                        // GlobVar.emailProfile :
                                        // GlobVar.encryptPhonnumber,
                                        profileController
                                                .emailProfile.isNotEmpty
                                            ? profileController.email.value
                                            : profileController
                                                .encryptPhonnumber.value,
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
                                        encryptPhonnumber: profileController
                                            .encryptPhonnumber.value,
                                      ),
                                      transition: Transition.leftToRight,
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
                  ),
                  sizeBoxHeight(20),
                  commonListTile(
                    onTap: () {
                      controller.currentIndex.value = 1;
                      GlobVar.login == true
                          ? Get.to(
                              MainScreen(),
                              transition: Transition.leftToRight,
                            )
                          : Get.to(
                              const WitoutLogginScreen(),
                              transition: Transition.downToUp,
                            );
                    },
                    icon: Icons.music_note_outlined,
                    text: 'Songs',
                  ),
                  commonListTile(
                    onTap: () {
                      GlobVar.login == true
                          ? Get.to(
                              const AlbumScreen(),
                              transition: Transition.leftToRight,
                            )
                          : Get.to(
                              const WitoutLogginScreen(),
                              transition: Transition.downToUp,
                            );
                    },
                    icon: Icons.album_outlined,
                    text: 'Albums',
                  ),
                  commonListTile(
                    onTap: () {
                      GlobVar.login == true
                          ? Get.to(
                              const ArtistScreen(),
                              transition: Transition.leftToRight,
                            )
                          : Get.to(
                              const WitoutLogginScreen(),
                              transition: Transition.downToUp,
                            );
                    },
                    icon: Icons.mic_external_on_outlined,
                    text: 'Artists',
                  ),
                  commonListTile(
                    onTap: () {
                      GlobVar.login == true
                          ? Get.to(
                              const AdminPlaylistScreen(),
                              transition: Transition.leftToRight,
                            )
                          : Get.to(
                              const WitoutLogginScreen(),
                              transition: Transition.downToUp,
                            );
                    },
                    icon: Icons.playlist_play_rounded,
                    text: 'Playlists',
                  ),
                  commonListTile(
                    onTap: () {
                      GlobVar.login == true
                          ? Get.to(
                              const DownloadScreen(),
                              transition: Transition.leftToRight,
                            )
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
                      if (GlobVar.login == true) {
                        queueSongsScreenController
                            .queueSongsListWithoutPlaylist();
                        Get.to(
                          QueueSongsScreen(whichScreen: 'library'),
                          transition: Transition.leftToRight,
                        );
                      } else {
                        Get.to(
                          const WitoutLogginScreen(),
                          transition: Transition.downToUp,
                        );
                      }
                    },
                    icon: Icons.queue_music,
                    text: 'Queue Songs',
                  ),
                  commonListTile(
                    onTap: () {
                      GlobVar.login == true
                          ? Get.to(
                              const FavoriteSongsScreen(),
                              transition: Transition.leftToRight,
                            )
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
                          ? Get.to(
                              const PlylistScreen(),
                              transition: Transition.leftToRight,
                            )
                          : Get.to(
                              const WitoutLogginScreen(),
                              transition: Transition.downToUp,
                            );
                      // Navigator.pushNamed(context, '/playlist');
                    },
                    icon: Icons.queue_music_outlined,
                    text: 'My Playlists',
                  ),
                ],
              );
            }
          },
        ),
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
