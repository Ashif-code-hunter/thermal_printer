import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:untitled/constants/font_manager.dart';

import '../../constants/color_manger.dart';
import '../../constants/style_manager.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,
    required this.onTap,
    this.height =60,
    this.width =200,

    this.color ,
    this.isCancel,
    required this.title}) : super(key: key);
  final void Function()? onTap;
  final String title;
  final Color? color;
  final double height;
  final double width;
  final bool? isCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: height.h,
            width:width.w,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isCancel ?? false ? const Color(0xffDB3445) : ColorManager.primaryLight,
                  isCancel ?? false ? const Color(0xffF71735) :  ColorManager.onPrimaryLight
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s16)),
            ),
            ),
    );
    }
}