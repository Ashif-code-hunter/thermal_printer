import 'package:flutter/material.dart';
import 'package:untitled/constants/color_manger.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/font_manager.dart';
import 'package:untitled/constants/style_manager.dart';

class LicenseExpiredScreen extends StatelessWidget {
  const LicenseExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 100.0,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Your license is expired.',
              style: getBoldStyle(color: ColorManager.grey,fontSize: FontSize.s22)
            ),
            SizedBox(height: 10),
            Text(
              'Please contact the Kenz Technology for renewing.',
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(color: ColorManager.grey,fontSize: FontSize.s18)
            ),
            kSizedBox40,
            Text(
              'Visit:',
              textAlign: TextAlign.center,
              style: getBoldStyle(color: ColorManager.grey,fontSize: FontSize.s18)
            ),
            Text(
              'www.kenztechnology.com',
              textAlign: TextAlign.center,
              style: getBoldStyle(color: ColorManager.grey,fontSize: FontSize.s18)
            ),

          ],
        ),
      ),
    );
  }
}