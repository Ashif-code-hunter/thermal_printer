import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/constants/app_routes.dart';
import 'package:untitled/screens/widget/rounded_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as im;
import '../../../constants/asset_manager.dart';
import '../../../constants/color_manger.dart';
import '../../../constants/constants.dart';
import '../../../constants/font_manager.dart';
import '../../../constants/style_manager.dart';
import '../../../provider/invoice_printing_screen.dart';
import '../../widget/Circular_progress_indicator_widget.dart';
import '../../widget/appbar_main_widget.dart';
import 'package:barcode/barcode.dart' as bar;

class InvoicePrintingScreen extends HookWidget {
   const InvoicePrintingScreen( {super.key,});







   @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isLoading = useState<bool>(false);
    // ValueNotifier<Uint8List?> theImageThatComesFromThePrinter = useState<Uint8List?>(null);
    // final ScreenshotController screenshotController = ScreenshotController();
    // final ScreenshotController screenshotController1 = ScreenshotController();
    dynamic buildBarcode(
        bar.Barcode bc,
        String data, {
          String? filename,
          double? width,
          double? height,
          double? fontHeight,
        }) {
      /// Create the Barcode
      final svg = bc.toSvg(
        data,
        width: width ?? 150,
        height: height ?? 40,
        fontHeight: fontHeight,
      );

      return svg;
    }

    final GlobalKey _printKey = GlobalKey();
    Future<void> printLabel() async {
      final RenderRepaintBoundary boundary = _printKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 2); // Adjust pixel ratio for your printer's resolution
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      await  context.read<InvoicePrintingNotifier>().printBluetoothInvoice(context: context,receipt:pngBytes).then((value) {
        if(value == "true"){
          // Navigator.pushReplacementNamed(context, barcodePrintingScreen);
        }
      });
    }

    return Scaffold(
      appBar:   PreferredSize(
          preferredSize: Size.fromHeight(100.0.h), // here the desired height
          child:   SafeArea(
            child: const     MainAppBarWidget(
                isFirstPage: true,
                title: ""
            ),
          ),
      ),
      body: Stack(
        children: [
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 kSizedBox20,
                  CustomButton(onTap: () async {
                    printLabel();
                   // isLoading.value = true;
                   // await screenshotController.capture(delay: const Duration(seconds: 1)).then((capturedImage) async {
                   //     theImageThatComesFromThePrinter.value = capturedImage;
                   //     if(((theImageThatComesFromThePrinter.value?.isNotEmpty ?? false) && theImageThatComesFromThePrinter.value != null)){
                   //      await  context.read<InvoicePrintingNotifier>().printBluetoothInvoice(context: context,receipt:theImageThatComesFromThePrinter.value!).then((value) {
                   //        if(value == "true"){
                   //          Navigator.pushReplacementNamed(context, barcodePrintingScreen);
                   //        }
                   //      });
                   //     }else{
                   //       showAwesomeDialogue(title: "Printing Error", content: "Please Try again later to print", type: DialogType.INFO_REVERSED);
                   //     }
                   //     isLoading.value = false;
                   //
                   //
                   //  }).catchError((onError) {
                   //    print(onError);
                   //    isLoading.value = false;
                   //
                   // });

                  }, title: "Print"),

                 kSizedBox20,
                  RepaintBoundary(
                    key: _printKey,
                    child: Container(
                      width:   250,
                      height: 94,
                      color: ColorManager.white,
                      child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width:166.66,
                                    child: Text("Almarai milk",style: getSemiBoldStyle(color: ColorManager.black,fontSize: FontSize.s12,height: 1),overflow: TextOverflow.ellipsis,maxLines: 2,)),
                                Text("99.00" ?? "",style: getBoldStyle(color: ColorManager.black,fontSize: FontSize.s14),)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("POP09" ?? "",style: getSemiBoldStyle(color: ColorManager.black,fontSize: FontSize.s12,height: 1),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                kSizedW7,
                                Text("PCS" ?? "",style: getSemiBoldStyle(color: ColorManager.black,fontSize: FontSize.s12),),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex:3,
                                    child:   SvgPicture.string(buildBarcode(bar.Barcode.code128(),
                                     "0000",))),
                                kSizedW20,
                                SizedBox(
                                    height:45,
                                    width:45,
                                    child: Image.asset( ImageAssets.houseLogo))
                              ],
                            )
                          ]
                      ),

                    ),
                  ),
                ],
              )),
          isLoading.value ?  Positioned.fill(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: const Color(0x66ffffff),
                    child: const CircularProgressIndicatorWidget(),
                  ))):kSizedBox
        ],
      ),
    );
  }
}

