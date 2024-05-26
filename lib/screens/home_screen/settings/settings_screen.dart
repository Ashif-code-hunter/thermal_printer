import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/app_routes.dart';
import 'package:untitled/constants/color_manger.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:untitled/screens/home_screen/widget/settings_tile_widget.dart';
import 'package:provider/provider.dart';
import '../../../constants/asset_manager.dart';
import '../../../constants/font_manager.dart';
import '../../../constants/values_manger.dart';
import '../../widget/appbar_main_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(onPressed: ()=> Navigator.pop(context),icon: Icon(Icons.arrow_back,color: ColorManager.black,),),
        title: Text("Settings",style: getBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s18),),),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            kSizedBox20,
            Center(
              child: CircleAvatar(

                radius: 80.r,
                backgroundImage: AssetImage(
                    ImageAssets.houseLogo),
              ),
            ),
            kSizedBox10,
            Text("Name: ",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),),
            Text("Email: ",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),),
            Text("Location Code: ",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),),
            Text("Mobile Batch:",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),),
            Text("User ID:",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s14),),
            kSizedBox30,
            SettingsTile(icons: Icons.print_rounded,title: "Setup Printer",onTap: ()=>Navigator.pushNamed(context, printerSettingsScreen),),
            kSizedBox30,
            InkWell(
              onTap: (){
                AwesomeDialog(
                    dismissOnTouchOutside: true,
                    context: context,
                    dialogType: DialogType.question,
                    animType: AnimType.bottomSlide,

                    title: "Confirmation",
                    desc: "Are you sure you want to logout",
                    descTextStyle: getSemiBoldStyle(color: ColorManager.primaryLight),
                    // desc:'Please login again',
                    btnCancelOnPress: () {},
                    btnOkText: "yes",
                    btnOkOnPress: () async {

                    },
                    btnOkColor: ColorManager.primaryLight)
                    .show();
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
                decoration: BoxDecoration(
                  color: ColorManager.filledColor2,
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded,size: FontSize.s28,),
                    kSizedW30,
                    Text("Logout",style: getBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s18),)
                  ],
                ),

              ),
            )
            


          ],
        ),
      ),
    );
  }
}
