import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/color_manger.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/font_manager.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:provider/provider.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({Key? key,this.show = false}) : super(key: key);
  final bool show;
  @override
  Widget build(BuildContext context) {

    return      Stack(
      children: <Widget>[
        Center(
          child: Container(
            width:show ? 80.h : 40.h,
            height: show ? 80.h : 40.h,
            child: CircularProgressIndicator.adaptive(
              backgroundColor: ColorManager.primaryLight,
              strokeWidth: show ? 8.0 : 4.0,
              valueColor: AlwaysStoppedAnimation<Color>(ColorManager.white  ),
            ),
          ),
        ),
       show ? Center(child: Text("${ 0.00.toStringAsFixed(2)}%",style: getBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),)):kSizedBox,
      ],
    );



    //   Center(
    //   child: CircularProgressIndicator.adaptive(
    //     backgroundColor: ColorManager.primaryLight,
    //     valueColor: AlwaysStoppedAnimation<Color>(ColorManager.white),
    //   ),
    // );
  }
}
