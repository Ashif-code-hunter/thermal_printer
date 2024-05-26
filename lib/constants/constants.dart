


import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:untitled/constants/asset_manager.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:untitled/constants/values_manger.dart';


import '../main.dart';
import 'app_routes.dart';
import 'color_manger.dart';
import 'font_manager.dart';

const kDivider = Divider(
  color: Color(0xFFDEDEDE),
  endIndent: 20,
  indent: 20,
  thickness: 1,
);

const kSizedBox = SizedBox();
SizedBox kSizedBox2 = SizedBox(
  height: 2.h,
);
SizedBox kSizedBox6 = SizedBox(
  height: 6.h,
);
SizedBox kSizedBox4 = SizedBox(
  height: 4.h,
);
SizedBox kSizedBox5 = SizedBox(
  height: 5.h,
);
SizedBox kSizedBox8 = SizedBox(
  height: 8.h,
);
SizedBox kSizedBox10 = SizedBox(
  height: 10.h,
);
SizedBox kSizedBox12 = SizedBox(
  height: 12.h,
);
SizedBox kSizedBox14 = SizedBox(
  height: 14.h,
);
SizedBox kSizedBox15 = SizedBox(
  height: 15.h,
);
SizedBox kSizedBox16 = SizedBox(
  height: 16.h,
);
SizedBox kSizedBox18 = SizedBox(
  height: 18.h,
);
SizedBox kSizedBox20 = SizedBox(
  height: 20.h,
);
SizedBox kSizedBox22 = SizedBox(
  height: 22.h,
);
SizedBox kSizedBox24 = SizedBox(
  height: 24.h,
);
SizedBox kSizedBox25 = SizedBox(
  height: 25.h,
);
SizedBox kSizedBox30 = SizedBox(
  height: 30.h,
);
SizedBox kSizedBox32 = SizedBox(
  height: 32.h,
);
SizedBox kSizedBox35 = SizedBox(
  height: 35.h,
);
SizedBox kSizedBox40 = SizedBox(
  height: 40.h,
);
SizedBox kSizedBox42 = SizedBox(
  height: 42.h,
);
SizedBox kSizedBox50 = SizedBox(
  height: 50.h,
);
SizedBox kSizedBox71 = SizedBox(
  height: 71.h,
);

SizedBox kSizedBox100 = SizedBox(
  height: 100.h,
);

SizedBox kSizedW5 = SizedBox(
  width: 5.w,
);
SizedBox kSizedW6 = SizedBox(
  width: 6.w,
);
SizedBox kSizedW7 = SizedBox(
  width: 7.w,
);
SizedBox kSizedW10 = SizedBox(
  width: 10.w,
);
SizedBox kSizedW12 = SizedBox(
  width: 12.w,
);
SizedBox kSizedW15 = SizedBox(
  width: 15.w,
);
SizedBox kSizedW20 = SizedBox(
  width: 20.w,
);
SizedBox kSizedW24 = SizedBox(
  width: 24.w,
);
SizedBox kSizedW30 = SizedBox(
  width: 30.w,
);
SizedBox kSizedW100 = SizedBox(
  width: 100.w,
);
class MyTextField {
  static const kTextFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    prefixIconColor: Colors.red,
    contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color:Color(0xffE0E0E0), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff2A4369), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffD32F2F), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffD32F2F), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(35.0)),
    ),
  );
}
//Emirates Id formatter
class EmiratesFormatter extends TextInputFormatter {
  final String sample;
  final String separator;

  EmiratesFormatter({required this.sample, required this.separator});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;
        if (newValue.text.length < sample.length &&
            sample[newValue.text.length - 1] == separator) {
          return TextEditingValue(
              text:
                  '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
              selection:
                  TextSelection.collapsed(offset: newValue.selection.end + 1));
        }
      }
    }
    return newValue;
  }
}

final NumberFormat amountFormatter = NumberFormat('###,###,##0.00');
final DateFormat timeFormatter = DateFormat("Hms");
final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");

//Share
// Future saveAndShare(Uint8List bytes) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final image = File('${directory.path}/flutter.png');
//   image.writeAsBytesSync(bytes);
//   const text = "Shared From ${AppStrings.appName} App";
//   await Share.shareFiles([image.path], text: text);
// }

//Logout Dialogue
// Future<bool> logOutAlert(BuildContext context) async {
//   final CacheService cache = CacheService();
//   return await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       title: Text(
//         S.of(context).signoutYourAccount,
//         style: getSemiBoldStyle(
//             color: ColorManager.black3, fontSize: FontSize.s16),
//       ),
//       content: Text(
//         S.of(context).youLooseCredentialsLogout,
//         style:
//             getRegularStyle(color: ColorManager.grey3, fontSize: FontSize.s14),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(
//               S.of(context).cancel,
//               style: getSemiBoldStyle(
//                   color: ColorManager.primary, fontSize: FontSize.s16),
//             )),
//         TextButton(
//             onPressed: () async {
//               await cache.deleteCache().then((_) {
//                 Navigator.of(context).pop(true);
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, loginRoute, (route) => false);
//               });
//             },
//             child: Text(
//               S.of(context).signout,
//               style: getSemiBoldStyle(
//                   color: ColorManager.primary, fontSize: FontSize.s16),
//             )),
//       ],
//     ),
//   );
// }

//SnackBar
void showSnackBar(
    {required BuildContext context,
    required String text,
    Color color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,

      margin: const EdgeInsets.symmetric(
          horizontal: AppMargin.m10, vertical: AppMargin.m20),
      content: Text(
        text,
        style: getBoldStyle(color: ColorManager.white),
      )));
}


Future<void> showAwesomeDialogue({required String title,required String content,required DialogType type,}) async {
  final player = AudioPlayer();
  if(title == "Error"){
    await player.play(AssetSource(MusicAssets.error),volume: 100);
  }else if(title =="Warning"){
    await player.play(AssetSource(MusicAssets.warning),volume: 100);
  }else if(title == "Info"){
    await player.play(AssetSource(MusicAssets.info),volume: 100);
  }else if(title == "Success"){
    await player.play(AssetSource(MusicAssets.success),volume: 100);
  }
  AwesomeDialog(
      dismissOnTouchOutside: true,
      context: navigatorKey.currentContext!,
      dialogType: type,
      showCloseIcon: false,

      animType: AnimType.scale,
      title: title,
      desc: content,
      descTextStyle: getSemiBoldStyle(color: ColorManager.primaryLight),
      // desc:'Please login again',
      // btnCancelOnPress: () {},
      btnOkText: "ok",
      btnOkColor: ColorManager.primaryLight)
      .show();
}

class MySeparator extends StatelessWidget {
  const MySeparator({
    Key? key,
    this.height = 1,
    this.color = Colors.black,
    this.isDouble = false,
  }) : super(key: key);

  final double height;
  final Color color;
  final bool isDouble;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Column(
          children: [
            kSizedBox4,
            Flex(
              children: List.generate(dashCount, (_) {
                if (isDouble) {
                  return Column(
                    children: [
                      SizedBox(
                        width: dashWidth,
                        height: dashHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: color),
                        ),
                      ),
                      kSizedBox2,
                      // Add spacing between double dashes
                      SizedBox(
                        width: dashWidth,
                        height: dashHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: color),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox(
                    width: dashWidth,
                    height: dashHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: color),
                    ),
                  );
                }
              }),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
            ),
            isDouble ? kSizedBox6:kSizedBox4 ,
          ],
        );
      },
    );
  }
}

//Image Picker
// Future<File?> pickImage(ImageSource source) async {
//   try {
//     final XFile? pickedImageFile = await ImagePicker().pickImage(
//       source: source,
//       imageQuality: 20,
//     );
//     if (pickedImageFile == null) return null;
//     final File imageTemporary = File(pickedImageFile.path);
//     return imageTemporary;
//   } on PlatformException catch (e) {
//     print("Failed to pick Image $e");
//   }
//   return null;
// }

