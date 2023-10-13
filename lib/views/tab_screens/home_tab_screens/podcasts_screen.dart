import 'package:edpal_music_app_ui/apihelper/api_helper.dart';
import 'package:edpal_music_app_ui/models/all_category_data_model.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PodcatsScreen extends StatefulWidget {
  const PodcatsScreen({super.key});

  @override
  State<PodcatsScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<PodcatsScreen> {
  final apiHelper = ApiHelper();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = false;
  AllCategoryDataModel? allCategoryDataModel;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchAllCategoryDataJson = await apiHelper.fetchAllCategoryData();

      allCategoryDataModel =
          AllCategoryDataModel.fromJson(fetchAllCategoryDataJson);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
          isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: allCategoryDataModel == null
            ?  Center(
                child: CircularProgressIndicator(
                color: AppColors.white,
              ))
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      sizeBoxHeight(20),
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 83 / 81,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: allCategoryDataModel!.allCategory!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    (allCategoryDataModel!
                                            .allCategory![index].picture) ??
                                        'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                     
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: lable(text: (allCategoryDataModel!
                                            .allCategory![index].title)!),
                              )
                              ],
                            );
                          })
                    ],
                  ),
                ),
              ));
  }
}
