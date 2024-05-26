import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/color_manger.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/font_manager.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:untitled/constants/values_manger.dart';
import 'package:untitled/screens/widget/appbar_main_widget.dart';

import '../../../constants/app_routes.dart';

class PrinterSettingsScreen extends StatelessWidget {
  const PrinterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainAppBarWidget(isFirstPage: false,title: "Printer Setup",),
            kSizedBox20,
            Padding(padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: Column(
              children: [
                Text("Let Me Know Which Type of Printer Do You use!🖨️",style: getSemiBoldStyle(color: ColorManager.primaryLight,fontSize: FontSize.s16),textAlign: TextAlign.left,),
                kSizedBox20,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: ()=>Navigator.pushNamed(context, bluetoothPrinterScreen),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: AppPadding.p16,vertical: AppPadding.p12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorManager.primaryLight,
                                ColorManager.onPrimaryLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bluetooth,color: ColorManager.white,),
                              kSizedW15,
                              Text("Bluetooth",style: getSemiBoldStyle(color: ColorManager.white,fontSize: FontSize.s14),)

                            ],
                          ),
                        ),
                      ),
                      kSizedW15,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.p16,vertical: AppPadding.p12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ColorManager.primaryLight,
                              ColorManager.onPrimaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.print,color: ColorManager.white,),
                            kSizedW15,
                            Text("In build",style: getSemiBoldStyle(color: ColorManager.white,fontSize: FontSize.s14),)
                          ],
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
