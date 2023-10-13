import 'package:country_code_picker/country_code_picker.dart';
import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/common_Widgets.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/validation.dart';
import 'package:edpal_music_app_ui/views/auth_screens/initial_login_screen.dart';
import 'package:edpal_music_app_ui/views/auth_screens/mobile%20auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  static String verify = "";

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  GlobalKey<FormState> myKey5 = GlobalKey<FormState>();
  final TextEditingController phoneNumber = TextEditingController();

  // ignore: deprecated_member_use, unused_field
  CountryCode _selectedCountry = CountryCode.fromCode('IN');

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

  bool isLoding = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          automaticallyImplyLeading: true,
          title: lable(
              text: AppStrings.continueWithMobileNumber,
              fontWeight: FontWeight.w500,
              fontSize: 17),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
              size: 26,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Get.offAll(const InitialLoginScreen());
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Form(
                key: myKey5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeBoxHeight(15),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF43464d),
                          ),
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
                            dialogTextStyle:
                                const TextStyle(color: Colors.grey),
                            dialogBackgroundColor:
                                AppColors.backgroundColor.withOpacity(0.9),
                            barrierColor: Colors.transparent,
                            alignLeft: false,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF4c4f56),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                controller: phoneNumber,
                                autofocus: true,
                                validator: (value) =>
                                    AppValidation.validatePhone(value!),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade400),
                                cursorColor: Colors.grey.shade400,
                                decoration: const InputDecoration(
                                  hintText: "Enter mobile number",
                                  errorText: null,
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizeBoxHeight(15),
                    lable(text: AppStrings.sent6DigitOpt, fontSize: 11),
                    sizeBoxHeight(600),
                    InkWell(
                      onTap: () async {
                        if (myKey5.currentState!.validate()) {
                          setState(() {
                            isLoding = true;
                          });
                          sendOtp();
                        } else {
                          snackBar('Enter valid mobile number');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 13,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: phoneNumber.text == ''
                              ? const Color(0xFF4c4f56)
                              : const Color(0xFF2cc5b3),
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
                                text: AppStrings.sentOtp,
                                color: phoneNumber.text == ''
                                    ? const Color(0xFF8e8e94)
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
            isLoding = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          MobileLoginScreen.verify = verificationId;
          if (kDebugMode) {
            print('PHONE PAGE VARIFI::::$verificationId');
          }
          snackBar('OTP sent Succesfully');
          setState(() {
            isLoding = false;
          });

          Get.to(OtpMobileAuthScreen(
            phoneNumber: phoneNumber,
            selectedCountry: _selectedCountry,
            varify: verificationId,
          ));
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
}
