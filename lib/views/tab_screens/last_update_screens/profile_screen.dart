// import 'dart:developer';
// import 'dart:io';
// // import 'dart:io';

// import 'package:edpal_music_app_ui/controllers/profile_controller.dart';
// import 'package:edpal_music_app_ui/utils/colors.dart';
// import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
// import 'package:edpal_music_app_ui/utils/size_config.dart';
// import 'package:edpal_music_app_ui/utils/strings.dart';
// import 'package:edpal_music_app_ui/utils/validation.dart';
// import 'package:edpal_music_app_ui/views/auth_screens/email%20auth/login_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   ProfileController profileController = Get.put(ProfileController());
//   File? pickedImage;
//   File? tempImage;


//   GlobalKey<FormState> myKey3 = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileNumberController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   @override
//   void initState() {
//     _initializeProfileData();
//     super.initState();
//   }

//   Future<void> _initializeProfileData() async {
//     await profileController.fetchProfile();

//     // Set the text field controller values after fetching the profile data
//     nameController.text = profileController.name;
//     emailController.text = profileController.email;
//     mobileNumberController.text = profileController.mobile_no;
//     addressController.text = profileController.address.isEmpty
//         ? 'address'
//         : profileController.address;

//     intitialImage();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.backgroundColor,
//           title: lable(text: AppStrings.profile, fontSize: 18),
//           centerTitle: true,
//           actions: [
//             commonIconButton(
//               icon: const Icon(
//                 Icons.logout,
//               ),
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool('isLoggedIn', false);
//                 await prefs.setString('imagePath', '');
//                 Get.offAll(const LogInScreen());
//               },
//             ),
//             sizeBoxWidth(15)
//           ],
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Obx(() {
//             if (profileController.isLoading.value) {
//               return  Center(
//                   heightFactor: 14,
//                   child: CircularProgressIndicator(
//                     color: AppColors.white,
//                   ));
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Form(
//                     key: myKey3,
//                     child: Column(
//                       children: [
//                         sizeBoxHeight(50),
//                         InkWell(
//                           onTap: () {
//                             pickImage(ImageSource.gallery);
//                           },
//                           child: Stack(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.indigo, width: 5),
//                                   borderRadius: const BorderRadius.all(
//                                     Radius.circular(100),
//                                   ),
//                                 ),
//                                 child: ClipOval(
//                                   child: pickedImage != null
//                                       ? Image.file(
//                                           pickedImage!,
//                                           width: 140,
//                                           height: 140,
//                                           fit: BoxFit.cover,
//                                         )
//                                       :  SizedBox(
//                                           width: 140,
//                                           height: 140,
//                                           child: Image.network(
//                                             profileController.profile_pic,
//                                             width: 140,
//                                             height: 140,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 5,
//                                 child: IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     Icons.add_a_photo_outlined,
//                                     color: Colors.blue,
//                                     size: 30,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         sizeBoxHeight(50),
//                         commonTextFiled(
//                           icon: Icons.person,
//                           controller: nameController,
//                           validator: (value) =>
//                               AppValidation.validateName(value!),
//                         ),
//                         sizeBoxHeight(20),
//                         commonTextFiled(
//                           icon: Icons.mail,
//                           controller: emailController,
//                           validator: (value) =>
//                               AppValidation.validateEmail(value!),
//                         ),
//                         sizeBoxHeight(20),
//                         commonTextFiled(
//                           icon: Icons.call,
//                           controller: mobileNumberController,
//                           validator: (value) =>
//                               AppValidation.validatePhone(value!),
//                         ),
//                         sizeBoxHeight(20),
//                         commonTextFiled(
//                             icon: Icons.location_on_outlined,
//                             controller: addressController),
//                         sizeBoxHeight(40),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40.0, vertical: 20.0),
//                               backgroundColor: AppColors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0)),
//                             ),
//                             onPressed: () async {
//                               if (myKey3.currentState!.validate()) {
//                                 final prefs =
//                                     await SharedPreferences.getInstance();
//                                 String path =
//                                     prefs.getString('imagePath') ?? '';
//                                 log("initpath:::$path");
//                                 File initialPath = File(path);
//                                 profileController
//                                     // ignore: prefer_if_null_operators
//                                     .editProfile(
//                                   name: nameController.text.isEmpty
//                                       ? profileController.name
//                                       : nameController.text,
//                                   email: emailController.text,
//                                   mobile_no: mobileNumberController.text,
//                                   address: addressController.text,
//                                   profile_pic: initialPath
//                                 )
//                                     .then((value) {
//                                   return snackBar('Successfully Profile Edit');
//                                 });
//                               } else {
//                                 snackBar('Something went wrong');
//                               }
//                             },
//                             child: lable(
//                                 text: AppStrings.save,
//                                 color: AppColors.backgroundColor),
//                           ),
//                         ),
//                         sizeBoxHeight(100),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }

//   pickImage(ImageSource imageType) async {
//     try {
//       final photo = await ImagePicker().pickImage(source: imageType);
//       if (photo == null) return;
//       final path = photo.path;
//       // profilePath = path;
//       final tempImage = File(path);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('imagePath', path);
//       if (kDebugMode) {
//         print('path::::: ${photo.path}');
//       }
//       setState(() {
//         pickedImage = tempImage;
//       });

//       Get.back();
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   intitialImage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String path = prefs.getString('imagePath') ?? '';
//       // initialProfilePath = path;
//       // ignore: unnecessary_null_comparison
//       if (path != '') {
//         final tempImage = File(path);
//         // await prefs.setString('imageFilePath', tempImage);

//         await prefs.setString('imagePath', path);
//         // print('path::::: ${photo.path}');
//         setState(() {
//           pickedImage = tempImage;
//         });

//         Get.back();
//       } else {
//           pickedImage = null;
//       }
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }
// }
