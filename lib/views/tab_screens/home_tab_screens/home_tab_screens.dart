import 'package:edpal_music_app_ui/controllers/home_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/home_screen.dart';
import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/podcasts_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/main_screen_controller.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final MainScreenController controller =
      Get.put(MainScreenController(initialIndex: 0));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        // appBar: AppBar(
        //   backgroundColor: AppColors.backgroundColor,
        //   // bottom: PreferredSize(
        //   //   preferredSize: const Size.fromHeight(0),
        //   //   child: Container(),
        //   // ),
        //   elevation: 0,
        // ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeBoxHeight(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TabBar(
                  // labelColor: AppColors.white,
                  // indicator: BoxDecoration(
                  //   color: Colors.transparent,
                  // ),
                  // overlayColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  unselectedLabelColor: Colors.transparent,
                  indicatorColor: AppColors.btnColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelStyle:
                      const TextStyle(color: Colors.transparent),
                  tabs: [
                    Obx(
                      () => Tab(
                        child: lable(
                          text: AppStrings.home,
                          fontWeight:
                              homeScreenController.selectedIndex.value == 0
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                          fontSize:
                              homeScreenController.selectedIndex.value == 0
                                  ? 20
                                  : 15,
                        ),
                      ),
                    ),
                    Obx(
                      () => Tab(
                        child: lable(
                          text: AppStrings.podcast,
                          fontWeight:
                              homeScreenController.selectedIndex.value == 1
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                          fontSize:
                              homeScreenController.selectedIndex.value == 1
                                  ? 20
                                  : 15,
                        ),
                      ),
                    ),
                  ],
                  onTap: (index) {
                    homeScreenController.changeTab(index);
                  },
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    HomeScreen(),
                    PodcatsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'package:edpal_music_app_ui/utils/assets.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/home_screen/home_screen.dart';
// // import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/song_categpry_screen.dart';
// import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/subjects_screen.dart';
// // import 'package:edpal_music_app_ui/views/tab_screens/home_tab_screens/tearms_screen.dart';
// import 'package:flutter/material.dart';

// class HomeTabScreen extends StatefulWidget {
//   const HomeTabScreen({super.key});

//   @override
//   State<HomeTabScreen> createState() => _HomeTabScreenState();
// }

// class _HomeTabScreenState extends State<HomeTabScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.backgroundColor,
//           leading: Icon(
//             Icons.menu,
//             color: AppColors.white,
//           ),
//           title: Image.asset(AppAsstes.appIconOrange, scale: 8),
//           centerTitle: true,
//           bottom: TabBar(
//             // overlayColor: Colors.transparent,
//             labelColor: AppColors.white,
//             unselectedLabelColor: Colors.grey.shade400,
//             indicatorColor: AppColors.white,
//             isScrollable: true,
//             tabs: const [
//               Tab(
//                 text: 'Home',
//               ),
//               Tab(
//                 text: 'Subjects',
//               ),
//               // Tab(
//               //   text: 'Terms',
//               // ),
//               // Tab(
//               //   text: 'Song Categories',
//               // ),
//               // text: ,
//             ],
//           ),
//         ),
//         body: const TabBarView(children: [
//           HomeScreen(),
//           PodcatsScreen(),
//           // TearmScreen(),
//           // SongCategoryScreen(),
//         ]),
//       ),
//     );
//   }
// }
