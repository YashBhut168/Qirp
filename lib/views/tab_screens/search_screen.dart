import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                sizeBoxHeight(20),
                commonTextField(
                  borderRadius: 35,
                  backgroundColor: const Color(0xFF383838),
                  cursorColor: Colors.grey,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 13, right: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  focusBorderColor: Colors.grey,
                  borderColor: Colors.transparent,
                  hintText: 'What are you looking for?',
                  textColor: Colors.grey,
                  lableColor: Colors.grey,
                  // controller: searchController,
                  // onChanged: (query) {
                  //   setState(() {
                  //     allSongsScreenController.filterAllSonglistTitles(query);
                  //   });
                  // },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(AppAsstes.animation.searchAnimation),
                      lable(text: 'You can search music name here.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
