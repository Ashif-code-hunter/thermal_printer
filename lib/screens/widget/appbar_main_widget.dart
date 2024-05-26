import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants/app_routes.dart';
import '../../constants/asset_manager.dart';
import '../../constants/color_manger.dart';
import '../../constants/constants.dart';
import '../../constants/font_manager.dart';
import '../../constants/style_manager.dart';
import '../../constants/values_manger.dart';


class MainAppBarWidget extends StatelessWidget {
  const MainAppBarWidget({
    Key? key,
    required this.isFirstPage,
    this.title
  }) : super(key: key);
  final bool isFirstPage;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      height: 90.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isFirstPage ?  Expanded(
              child: Row(
                children: [
                  InkWell(

                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: AssetImage(ImageAssets.houseLogo,)
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, settingsScreen);
                    },
                  ),
                  kSizedW10,
                  Flexible(
                    child: Text(
                      "Howdy, Bro!!",
                      style: getBoldStyle(
                          color: ColorManager.primaryLight,
                          fontSize: FontSize.s20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ) : Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded),
                ),
                kSizedW10,
                Text(
                  title ?? "",
                  style: getBoldStyle(
                      color: ColorManager.primaryLight,
                      fontSize: FontSize.s20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
