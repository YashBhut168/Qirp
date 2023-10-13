import 'dart:developer';
import 'dart:io';

import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
import 'package:edpal_music_app_ui/utils/assets.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/tab_screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String encryptPhonnumber;
  const EditProfileScreen({super.key, required this.encryptPhonnumber});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
 ProfileController profileController = Get.put(ProfileController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();


  GlobalKey<FormState> myKey6 = GlobalKey<FormState>();

  String dropdownValue = 'Male';

  File? pickedImage;
  File? tempImage;

  @override
  void initState() {
    // profileController.fetchProfile();

    super.initState();
    // Future.delayed(Duration.zero, () async {
      _initializeProfileData();
    // });
  }

  Future<void> _initializeProfileData() async {
    try {
      nameController.text = profileController.name.value.isNotEmpty
          ? profileController.name.value
          : nameController.text;
      emailController.text = profileController.email.value.isNotEmpty
          ? profileController.email.value
          : emailController.text;
      ageController.text = profileController.age.value.isNotEmpty
          ? profileController.age.value
          : ageController.text;
      mobileNumberController.text = profileController.mobile_no.value.isNotEmpty
          ? profileController.mobile_no.value
          : mobileNumberController.text;
      dropdownValue = profileController.gender.value == ''
          ? 'Male'
          : profileController.gender.value;
      await profileController.fetchProfile();

      intitialImage();
    } catch (e) {
      if (kDebugMode) {
        print('Fetch profile failed: $e');
      }
    }
  }
   

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    ageController.dispose();
    genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Obx(
              () {
                if (profileController.isLoading.value) {
                  return Center(
                      heightFactor: 14,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ));
                } else {
                  return Form(
                    key: myKey6,
                    child: Column(
                      children: [
                        sizeBoxHeight(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  profileController.fetchProfile();
                                  Get.to(MainScreen());
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: AppColors.white,
                                  size: 15,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if (myKey6.currentState!.validate()) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    String path =
                                        prefs.getString('imagePath') ?? '';
                                    log("initpath:::$path");
                                    File initialPath = File(path);
                                    profileController
                                        // ignore: prefer_if_null_operators
                                        .editProfile(
                                      name:
                                          //  nameController.text.isEmpty
                                          //     ? profileController.name.value
                                          //     :
                                          nameController.text,
                                      email:
                                          // emailController.text.isEmpty
                                          //     ? profileController.email.value
                                          //     :
                                          emailController.text,
                                      mobile_no:
                                          // mobileNumberController.text.isEmpty
                                          //     ? profileController.mobile_no.value
                                          //     :
                                          mobileNumberController.text,
                                      profile_pic: initialPath,
                                      age:
                                          //  ageController.text.isEmpty
                                          //     ? profileController.age.value
                                          //     :
                                          ageController.text,
                                      gender: dropdownValue,
                                    )
                                        .then((value) {
                                      snackBar('Successfully Profile Edit');
                                      profileController.fetchProfile();
                                      Get.to(MainScreen());
                                    });
                                  } else {
                                    snackBar('Something went wrong');
                                  }
                                },
                                child: lable(
                                  text: 'Save',
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeBoxHeight(5),
                        InkWell(
                          onTap: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: Stack(
                            children: [
                              ClipOval(
                                child: pickedImage != null
                                    ? Image.file(
                                        pickedImage!,
                                        width: 180,
                                        height: 180,
                                        fit: BoxFit.fill,
                                      )
                                    : profileController.profile_pic.value == ''
                                        ? SizedBox(
                                            width: 180,
                                            height: 180,
                                            child: Image.asset(
                                              AppAsstes.user,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 180,
                                            height: 180,
                                            child: FadeInImage(
                                              placeholder: const AssetImage(
                                                  AppAsstes.user),
                                              image: NetworkImage(
                                                  profileController
                                                      .profile_pic.value),
                                              width: 180,
                                              height: 180,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                              ),
                              Positioned(
                                bottom:
                                    profileController.profile_pic.value == '' &&
                                            pickedImage == null
                                        ? 20
                                        : 0,
                                right:
                                    profileController.profile_pic.value == '' &&
                                            pickedImage == null
                                        ? 20
                                        : 5,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        sizeBoxHeight(50),
                        // lable(text: nameController.text),
                        commonTextField(
                          backgroundColor: const Color(0xFF30343d),
                          borderRadius: 0,
                          borderColor: const Color(0xFF30343d),
                          cursorColor: AppColors.white,
                          hintText: AppStrings.email,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: lable(
                              text: "Edit",
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          lableColor: Colors.white,
                          controller: emailController,
                          validator: (value) =>
                              AppValidation.validateEmail(value!),
                        ),
                        sizeBoxHeight(30),
                        commonTextField(
                          backgroundColor: const Color(0xFF30343d),
                          borderRadius: 0,
                          borderColor: const Color(0xFF30343d),
                          cursorColor: AppColors.white,
                          hintText: AppStrings.fullName,
                          controller: nameController,
                          lableColor: Colors.white,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: lable(
                              text: "Edit",
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          textColor: Colors.grey,
                          validator: (value) =>
                              AppValidation.validateName(value!),
                        ),
                        commonTextField(
                          backgroundColor: const Color(0xFF30343d),
                          borderRadius: 0,
                          borderColor: const Color(0xFF30343d),
                          cursorColor: AppColors.white,
                          keyBoardType: TextInputType.phone,
                          controller: mobileNumberController,
                          validator: (value) =>
                              AppValidation.validatePhone(value!),
                          hintText: widget.encryptPhonnumber.isEmpty
                              ? 'Enter Phonenumber'
                              : widget.encryptPhonnumber,
                          isEnable:
                              widget.encryptPhonnumber.isEmpty ? true : false,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: lable(
                              text: "Edit",
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          lableColor: Colors.white,
                          textColor: widget.encryptPhonnumber.isEmpty
                              ? Colors.grey
                              : AppColors.white,
                        ),
                        commonTextField(
                          backgroundColor: const Color(0xFF30343d),
                          borderRadius: 0,
                          borderColor: const Color(0xFF30343d),
                          cursorColor: AppColors.white,
                          hintText: 'Age',
                          controller: ageController,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: lable(
                              text: "Edit",
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          textColor: Colors.grey,
                          lableColor: AppColors.white,
                          keyBoardType: TextInputType.phone,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          color: const Color(0xFF30343d),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: dropdownValue,
                                iconDisabledColor: Colors.transparent,
                                iconEnabledColor: Colors.transparent,
                                underline: Container(),
                                dropdownColor: const Color(0xFF30343d),
                                items: <String>[
                                  'Male',
                                  'Female',
                                  'Other',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    key: UniqueKey(),
                                    value: value,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return SizedBox(
                                          width: constraints.maxWidth > 150.0
                                              ? 220.0
                                              : constraints.maxWidth,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                              ),
                              lable(
                                text: 'Edit',
                                fontSize: 12,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final path = photo.path;
      // profilePath = path;
      final tempImage = File(path);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', path);
      if (kDebugMode) {
        print('path::::: ${photo.path}');
      }
      setState(() {
        pickedImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  intitialImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String path = prefs.getString('imagePath') ?? '';
      // initialProfilePath = path;
      // ignore: unnecessary_null_comparison
      if (path != '') {
        final tempImage = File(path);
        // await prefs.setString('imageFilePath', tempImage);

        await prefs.setString('imagePath', path);
        // print('path::::: ${photo.path}');
        setState(() {
          pickedImage = tempImage;
        });

        // Get.back();
      } else {
        pickedImage = null;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
