import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/color_manger.dart';
import '../../../constants/constants.dart';
import '../../../constants/font_manager.dart';
import '../../../constants/style_manager.dart';
import '../../../constants/values_manger.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,required this.onTap, required this.icons, required this.title,  this.color
  });
  final Function() onTap;
  final IconData icons;
  final String title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
        decoration: BoxDecoration(
          color: ColorManager.filledColor,
        ),
        child: Row(
          children: [
            Icon(icons,size: FontSize.s28,color:color ?? ColorManager.primaryLight ,),
            kSizedW30,
            Text(title,style: getBoldStyle(color: color ?? ColorManager.primaryLight,fontSize: FontSize.s18),)
          ],
        ),

      ),
    );
  }
}
