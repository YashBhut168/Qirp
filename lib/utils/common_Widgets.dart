// ignore_for_file: file_names

import 'package:edpal_music_app_ui/utils/colors.dart';
import 'package:edpal_music_app_ui/utils/size_config.dart';
import 'package:edpal_music_app_ui/utils/strings.dart';
import 'package:edpal_music_app_ui/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Widget lable(
    {required String text,
    double? fontSize,
    FontWeight? fontWeight,
    int? maxLines,
    TextAlign? textAlign,
    double? letterSpacing,
    Color? color}) {
  return Text(
    text,
    maxLines: maxLines ?? 1,
    textAlign: textAlign,
    style: TextStyle(
        color: color ?? AppColors.white,
        overflow: TextOverflow.ellipsis,
        fontSize: fontSize ?? 14.0,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing),
  );
}

Widget containerIcon({
  IconData? icon,
  EdgeInsetsGeometry? padding,
  void Function()? onTap,
  Color? containerColor,
  Color? iconColor,
  BoxBorder? border,
  double? height,
  double? width,
  Image? image,
  double? borderRadius,
  double? iconSize,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height ?? 60,
      width: width ?? 60,
      // padding: padding,
      decoration: BoxDecoration(
          color: containerColor ?? AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 27)),
          border: border),
      child: Center(
          child: image ??
              Icon(
                icon,
                size: iconSize ?? 25,
                color: iconColor,
              )),
    ),
  );
}

Icon customIcon({required IconData icon,double? size}) {
  return Icon(
    icon,
    size: size ?? 20,
    color: AppColors.white,
  );
}

Widget commonTextField(
    {Color textColor = Colors.grey,
    TextEditingController? controller,
    bool border = true,
    Color backgroundColor = Colors.white,
    Color? borderColor,
    Color? focusBorderColor,
    Widget? prefix,
    Widget? suffix,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    bool isEnable = true,
    bool inputFormatter = false,
    bool isDouble = false,
    bool notShowText = false,
    TextInputType keyBoardType = TextInputType.emailAddress,
    String hintText = '',
    double? borderRadius,
    bool readOnly = false,
    Color? cursorColor,
    Color? lableColor,
    Function()? onTap,
    TextStyle? hintStyle,
    TextAlign textAlign = TextAlign.left,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode}) {
  RxBool notShow = notShowText.obs;
  return Obx(
    () => TextFormField(
      controller: controller,
      validator: validator,
      onTap: onTap,
      enabled: isEnable,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      cursorColor: cursorColor ?? const Color(0Xff14213d),
      focusNode: focusNode,
      obscureText: notShow.value,
      keyboardType: keyBoardType,
      onChanged: onChanged,
      style: TextStyle(color: lableColor),
      inputFormatters: inputFormatter
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          // horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(15),
        ),
        errorMaxLines: 2,
        isDense: true,
        hintText: hintText.tr,
        filled: true,
        fillColor: backgroundColor,
        // constraints: BoxConstraints(
        //   minHeight: getProportionateScreenHeight(58),
        //   maxHeight: getProportionateScreenHeight(58),
        // ),
        enabledBorder: border
            ? OutlineInputBorder(
                borderSide: BorderSide(color: borderColor ?? AppColors.white),
                borderRadius: BorderRadius.circular(
                  borderRadius ?? getProportionateScreenHeight(7),
                ),
              )
            : null,
        focusedBorder: border
            ? OutlineInputBorder(
                borderSide:
                    BorderSide(color: focusBorderColor ?? AppColors.white),
                borderRadius: BorderRadius.circular(
                  borderRadius ?? getProportionateScreenHeight(7),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 7,
          ),
        ),
        // errorStyle: TextStyle(color: ),
        alignLabelWithHint: false,
        hintStyle: hintStyle ??
            AppTextStyles.textNormal(txtColor: textColor, fontSize: 16),
        suffixIconConstraints: BoxConstraints(
          maxHeight: getProportionateScreenHeight(48),
        ),
        prefixIconConstraints: BoxConstraints(
          maxWidth: prefix == null
              ? getProportionateScreenWidth(20)
              : double.infinity,
          minWidth: getProportionateScreenWidth(20),
        ),
        suffixIcon: suffix ??
            (notShowText
                ? IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () => notShow.value = !notShow.value,
                    icon: Icon(
                      notShow.value ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : null),
        prefixIcon: prefix ?? const SizedBox(),
      ),
    ),
  );
}

ElevatedButton customElevatedButton(
    {required String text, required void Function()? onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.btnColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        lable(text: text, fontSize: 17),
        sizeBoxWidth(12),
        Icon(
          Icons.login,
          size: 24.0,
          color: AppColors.white,
        ),
      ],
    ),
  );
}

IconButton commonIconButton(
    {required Widget icon, void Function()? onPressed}) {
  return IconButton(
    icon: icon,
    color: AppColors.white,
    onPressed: onPressed,
  );
}

TextFormField commonTextFiled(
    {required TextEditingController? controller,
    IconData? icon,
    String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    style: TextStyle(
      color: AppColors.white,
    ),
    decoration: InputDecoration(
      errorStyle: TextStyle(color: AppColors.white),
      icon: Icon(
        icon,
        color: AppColors.white,
        size: 26,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.white,
        ),
      ),
    ),
  );
}

snackBar(String message, {String title = "", BuildContext? context}) {
  return Get.snackbar(
    title,
    message,
    colorText: Colors.black,
    titleText: const SizedBox(height: 0),
    padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(20),
      vertical: getProportionateScreenHeight(15),
    ),
    // icon: Icon(Icons.error),
    messageText: Text(message,
        style: AppTextStyles.textNormal(
            fontSize: 16, txtColor: AppColors.backgroundColor)),
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(getProportionateScreenHeight(20)),
    borderRadius: 7,
    backgroundColor: AppColors.white,
  );
}

Widget commonListTilePlaylist({
  required icon,
  required String text,
  iconSize,
  iconColor,
  Widget? trailing,
}) {
  return Container(
    color: Colors.transparent,
    child: ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
      leading: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.white,
          size: iconSize ?? 30,
        ),
      ),
      title: lable(
        text: text,
        fontSize: 12,
      ),
      trailing: trailing,
    ),
  );
}

Widget commonViewAll({void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    
    // () {
    //   Get.to(
    //     SeeAllSongScreen(
    //       homeCategoryData: onTapData,
    //     ),
    //   );
    // },
    child: Column(
      children: [
        containerIcon(
          border: Border.all(color: AppColors.btnColor),
          containerColor: AppColors.backgroundColor,
          borderRadius: 60,
          icon: Icons.arrow_forward,
          iconColor: AppColors.btnColor,
        ),
        sizeBoxHeight(3),
        lable(
          text: AppStrings.viewAll,
          color: AppColors.btnColor,
        )
      ],
    ),
  );
}

Widget commonAuthContainer({
  String? image,
  String? text,
  void Function()? onTap,
  bool? isLoading,
  bool? isIcon,
  IconData? icon,
  double? imageHeight,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
        decoration: const BoxDecoration(
          color: Color(0xFF005FF7),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: isLoading == true
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
            : Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizeBoxWidth(14),
                  isIcon == true
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Icon(
                            icon,
                            size: 27,
                            color: Colors.white,
                          ),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(left: 6,top: 6,bottom: 6),
                        child: Image.asset(image ?? '', height: imageHeight ?? 16),
                      ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: lable(
                        text: text ?? '',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}
