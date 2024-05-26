
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../screens/home_screen/settings/bluetooth_printer_setup_screen.dart';
import 'general_notifier.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:image/image.dart' as im;

class InvoicePrintingNotifier extends ChangeNotifier{

  bool _isDone = false;

  bool get getIsDone => _isDone;

  Future<List<int>> makeBluetoothInvoice({required BuildContext context,required Uint8List receipt}) async {

    List<int> bytes = [];


    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    ///image
    final im.Image? image = im.decodeImage(receipt);
    bytes += generator.image(image!,align: PosAlign.center);
    // bytes += generator.feed(1);
    return bytes;

  }

  Future<String?> printBluetoothInvoice({required BuildContext context,required Uint8List receipt}) async {

    final generalNotifier = context.read<GeneralNotifier>();

    if((generalNotifier.getBluetoothPrinterMacID?.isNotEmpty ?? false) && generalNotifier.getBluetoothPrinterMacID !=null) {



      String? isConnected = await BluetoothThermalPrinter.connectionStatus;

      if (isConnected == "true") {
        List<int> bytes = await makeBluetoothInvoice(context: context,receipt: receipt);
        final p =  await BluetoothThermalPrinter.writeBytes(bytes);
        // print("ssss $p");
        return p;
      } else {
        // showAwesomeDialogue(title: "Print Error", content: "Could not print at this moment, please try again after connecting printer", type: DialogType.ERROR);
        // Navigator.pushNamed(context, bluetoothPrinterScreen );
        Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothPrinterScreen(isAccessInside: true,)));
        //Hadnle Not Connected Senario
      }
    }else{
      showAwesomeDialogue(title: "Print Warning", content: "Please connect Printer through settings" , type: DialogType.info);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothPrinterScreen(isAccessInside: true,)));
    }
    return null;
  }


}


