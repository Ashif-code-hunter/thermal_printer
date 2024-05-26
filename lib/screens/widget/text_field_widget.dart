import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/font_manager.dart';
import 'package:provider/provider.dart';


import '../../../constants/color_manger.dart';
import '../../../constants/style_manager.dart';
import '../../../constants/values_manger.dart';
import '../../constants/asset_manager.dart';

class TextFormFieldCustom extends HookWidget {
  final TextEditingController controller;
  final String? hintName;
  final IconData? icon;
  final ValueNotifier<bool>? isSearch;
  final bool isObscureText,suffixEnable,isProductCode,autoFocus;
  final int? maxLength,maxLine;
  final TextInputType inputType;
  final FocusNode? focus;
  final Color? color;
  final bool isEnable, isEditable, isReadOnly;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingCompleted;
  final void Function()? onEditTap;
  final void Function()? onScannerTap;
  final double paddingWidth;


  const TextFormFieldCustom(
      {required this.controller,
        this.hintName,
        this.icon,
        this.onChanged,
        this.validator,
        this.isEditable = true,
        this.maxLength,
        this.maxLine,
        this.color,
        this.onEditingCompleted,
        this.inputFormatters,
        this.isObscureText = false,
        this.inputType = TextInputType.text,
        this.isEnable = true,
        this.onTap,
        this.onFieldSubmitted,
        this.onEditTap,
        this.onScannerTap,
        this.focus,
        this.isReadOnly = false,
        this.suffixEnable = false,
        this.isProductCode = false,
        this.autoFocus = false,
        this.isSearch,
        this.paddingWidth = AppPadding.p20,

        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      obscureText: isObscureText,
      readOnly: isReadOnly,
      focusNode: focus,
      autofocus: autoFocus,
      onTap: onTap,
      enabled: isEnable,
      style: getSemiBoldStyle(color:ColorManager.black),
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintName';
            }
            return null;
          },
      onEditingComplete: onEditingCompleted,
      onFieldSubmitted: onFieldSubmitted,

      onChanged:  onChanged,
      maxLines: maxLine,
      autocorrect: isEditable,
      enableSuggestions: isEditable,
      enableInteractiveSelection: isEditable,
      maxLength: maxLength,
      decoration: InputDecoration(

        floatingLabelStyle: getSemiBoldStyle(color:ColorManager.primaryLight ),
        enabledBorder: OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color:ColorManager.primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:const  BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color:ColorManager.primaryLight),
        ),
        prefixIcon: icon!=null ? Icon(
          icon,
          color: ColorManager.primaryLight ,
        ):null,
        suffixIcon: suffixEnable ? !isProductCode ?Row(
          mainAxisSize: MainAxisSize.min,
          children: [
           InkWell(
              onTap: onEditTap,
              child:  Icon(  isSearch?.value ?? false ? Icons.edit_off_rounded : Icons.edit,color: ColorManager.black,size: FontSize.s24,),
            ),
            kSizedW15,
            InkWell(
                onTap: onScannerTap,
                child:  Image.asset(ImageAssets.barcode,height: 32.h,)
            ),
            kSizedW10,
          ],
        ):  Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onEditTap,
                  child:  Text(  "Search",style: getSemiBoldStyle(color: ColorManager.black),),
                ),
              ),
            ),
          ],
        ):kSizedBox,
        // hintText: hintName,
        labelText: hintName,
        labelStyle: getBoldStyle(color:ColorManager.primaryLight),
        fillColor: color ?? ColorManager.white ,
        filled: true,
      ),
    );
  }
}