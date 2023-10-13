import 'package:edpal_music_app_ui/controllers/all_song_screen_controller.dart';
import 'package:edpal_music_app_ui/controllers/detail_screen_controller.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/views/tab_screens/my_library_screens/playlist_screens/playlist_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddSongsScreen extends StatefulWidget {
  final String myPlaylistId;
  final String playlistTitle;
  List<int>? checkedIds;

  AddSongsScreen(
      {super.key,
      required this.myPlaylistId,
      required this.playlistTitle,
      this.checkedIds});

  @override
  State<AddSongsScreen> createState() => _AddSongsScreenState();
}

class _AddSongsScreenState extends State<AddSongsScreen> {
  AllSongsScreenController allSongsScreenController =
      Get.put(AllSongsScreenController());
  DetailScreenController detailScreenController =
      Get.put(DetailScreenController());

  @override
  void initState() {
    super.initState();
    allSongsScreenController.allSongsList(checkedIds: widget.checkedIds ?? []);
    setState(() {
      widget.checkedIds;
      checkedIds.toList();
      allSongsScreenController.isChecked;
    });

    // checkedIds = (widget.checkedIds)!.isNotEmpty ? (widget.checkedIds)! : [];
    //  initChecked();
  }

  // List<bool> isChecked = [];
  List<int> checkedIds = [];

  // void initChecked() {
  //   if (allSongsScreenController.allSongsListModel != null ) {
  //     setState(() {
  //       isChecked = List<bool>.generate(
  //         allSongsScreenController.allSongsListModel!.data!.length,
  //         (index) => false,
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // print(isChecked);
    }
    if (kDebugMode) {
      print(checkedIds);
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: lable(
            text: AppStrings.addSongs,
            fontSize: 18,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 30),
            child: InkWell(
                onTap: () {
                  Get.off(const PlylistScreen());
                },
                child: lable(text: AppStrings.cancel)),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => allSongsScreenController.isLoading.value == true
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      sizeBoxHeight(20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allSongsScreenController
                                .allSongsListModel!.data!.length,
                            itemBuilder: (context, index) {
                              var allSongsListData = allSongsScreenController
                                  .allSongsListModel!.data![index];

                              return CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                                fillColor:
                                    const MaterialStatePropertyAll(Colors.grey),
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -1),
                                onChanged: (value) {
                                  setState(() {
                                    if (allSongsScreenController
                                            .isChecked!.length <=
                                        index) {
                                      allSongsScreenController.isChecked!
                                          .add(value!);
                                    } else {
                                      allSongsScreenController
                                          .isChecked![index] = value!;
                                    }
                                    if (value) {
                                      checkedIds
                                          .add(int.parse(allSongsListData.id!));
                                    } else {
                                      checkedIds.remove(
                                          int.parse(allSongsListData.id!));
                                    }
                                  });
                                },
                                autofocus: true,
                                value: allSongsScreenController
                                            .isChecked!.length >
                                        index
                                    ? allSongsScreenController.isChecked![index]
                                    : false,
                                secondary: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.network(
                                    (allSongsListData.image) ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                    height: 70,
                                    width: 70,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                title: lable(
                                    text: (allSongsListData.title)!,
                                    fontSize: 12),
                                subtitle: lable(
                                  text: (allSongsListData.description)!,
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              );
                            }),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      sizeBoxHeight(30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF30343d),
                                ),
                                onPressed: () {},
                                child: lable(
                                  text: '${checkedIds.length} Songs Added',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            sizeBoxWidth(15),
                            Expanded(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2ac5b3),
                              ),
                              onPressed: () {
                                if (kDebugMode) {
                                  print(checkedIds);
                                }
                                detailScreenController
                                    .addSongInPlaylist(
                                  playlistId: widget.myPlaylistId,
                                  songsId: checkedIds,
                                )
                                    .then((value) {
                                  Get.off(const PlylistScreen());

                                  detailScreenController.success == "true"
                                      ? snackBar(
                                          '${AppStrings.songAddedInPlaylistSuccessfully} ${widget.playlistTitle}')
                                      : snackBar(
                                          (detailScreenController.message)!);
                                });
                              },
                              child: lable(
                                text: 'save Playlist',
                                fontSize: 12,
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

                            // ListTile(
                            //   visualDensity: const VisualDensity(
                            //       horizontal: -4, vertical: -1),
                            //   leading: ClipRRect(
                            //     borderRadius: BorderRadius.circular(11),
                            //     child: Image.network(
                            //       (allSongsListData.image) ??
                            //           'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                            //       height: 70,
                            //       width: 70,
                            //       filterQuality: FilterQuality.high,
                            //     ),
                            //   ),
                            //   title: lable(text: (allSongsListData.title)!),
                            //   subtitle:
                            //       lable(text: (allSongsListData.description)!),
                            //       trailing: Checkbox(value: null,),
                            // );