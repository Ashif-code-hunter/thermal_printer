
import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/constants/app_routes.dart';
import 'package:untitled/constants/style_manager.dart';
import 'package:untitled/screens/home_screen/settings/widget/bluetooth_widgets.dart';
import 'package:untitled/screens/widget/appbar_main_widget.dart';
import 'package:untitled/screens/widget/rounded_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as im;
import 'package:screenshot/screenshot.dart';

import '../../../constants/color_manger.dart';
import '../../../constants/constants.dart';
import '../../../constants/font_manager.dart';
import '../../../provider/general_notifier.dart';

final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();
final Map<DeviceIdentifier, ValueNotifier<bool>> isConnectingOrDisconnecting = {};
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _btStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/deviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _btStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _btStateSubscription?.cancel();
    _btStateSubscription = null;
  }
}

class BluetoothPrinterScreen extends StatelessWidget {
  const BluetoothPrinterScreen({Key? key,this.isAccessInside = false}) : super(key: key);
 final bool isAccessInside ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothAdapterState>(
          stream: FlutterBluePlus.adapterState,
          initialData: BluetoothAdapterState.unknown,
          builder: (c, snapshot) {
            final adapterState = snapshot.data;
            if (adapterState == BluetoothAdapterState.on) {
              return  FindDevicesScreen(isAccessInside: isAccessInside,);
            } else {
              FlutterBluePlus.stopScan();
              return BluetoothOffScreen(adapterState: adapterState);
            }
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyA,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${adapterState != null ? adapterState.toString().split(".").last : 'not available'}.',
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(color: Colors.white),
              ),
              if (Platform.isAndroid)
                ElevatedButton(
                  child: const Text('TURN ON'),
                  onPressed: () async {
                    try {
                      if (Platform.isAndroid) {
                        await FlutterBluePlus.turnOn();
                      }
                    } catch (e) {
                      final snackBar = snackBarFail(prettyException("Error Turning On:", e));
                      snackBarKeyA.currentState?.removeCurrentSnackBar();
                      snackBarKeyA.currentState?.showSnackBar(snackBar);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key,required this.isAccessInside}) : super(key: key);
  final bool isAccessInside;
  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  bool connected = false;
  String name = "";
  @override
  Widget build(BuildContext context) {


    Future<void> setConnect(String mac) async {
      final String? result = await BluetoothThermalPrinter.connect(mac);
      print("state conneected $result");
      if (result == "true") {
        setState(() {
          connected = true;
        });
      }
    }

    Future<List<int>?> getTicket() async {
      try{
        List<int> bytes = [];
        CapabilityProfile profile = await CapabilityProfile.load();
        final generator = Generator(PaperSize.mm80, profile);

        bytes += generator.text("Demo Shop",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size3,
              width: PosTextSize.size3,

            ),
            linesAfter: 1);
        bytes += generator.text("Working",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size3,
              width: PosTextSize.size3,
            ),
            linesAfter: 1);

        // final encodedStr = utf8.encode("يمليمبرس برملبيرو");
        // bytes += generator.textEncoded(Uint8List.fromList(encodedStr
        // ),styles: PosStyles(fontType: PosFontType.fontB)
        // );
        // bytes += generator.
        // bytes += generator.hr();

        bytes += generator.cut();
        return bytes;
      }catch(e){
      }
    return null;
    }

    Future<String?> printTicket() async {
      String? isConnected = await BluetoothThermalPrinter.connectionStatus;
      if (isConnected == "true") {
        try{
          if(widget.isAccessInside == true){
            showAwesomeDialogue(title: "Print Setup Success", content: "Please try again", type: DialogType.success);

          }else {
            List<int>? bytes = await getTicket();
            await BluetoothThermalPrinter.writeBytes(bytes!);
          }
        }catch(e){
          Navigator.pushNamed(context, printerSettingsScreen);
          print(e);
        }
        return "OK";
      } else {
        showAwesomeDialogue(title: "Print Error", content: "Please unpair and you device and restart bluetooth", type: DialogType.info);
      }
      return null;
    }
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:  Size(double.infinity, 150.h),
          child: const SafeArea(child: MainAppBarWidget(isFirstPage: false,title: "Find Devices")),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {}); // force refresh of connectedSystemDevices
            if (FlutterBluePlus.isScanningNow == false) {
              FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
            }
            return Future.delayed(Duration(milliseconds: 500)); // show refresh icon breifly
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                            StreamBuilder<List<BluetoothDevice>>(
                              stream: Stream.fromFuture(FlutterBluePlus.connectedSystemDevices),
                              initialData: const [],
                              builder: (c, snapshot) => Column(
                                children: (snapshot.data ?? [])
                                    .map((d) => ListTile(
                                  title: Text(d.localName,style: getBoldStyle(color: Colors.black),),
                                  subtitle: Text(d.remoteId.toString(),style: getSemiBoldStyle(color: Colors.black),),
                                  trailing: StreamBuilder<BluetoothConnectionState>(
                                    stream: d.connectionState,
                                    initialData: BluetoothConnectionState.disconnected,
                                    builder: (c, snapshot) {
                                      if (snapshot.data == BluetoothConnectionState.connected) {
                                        return CustomButton(
                                            height: 50.h,
                                            width: 110.w,
                                            onTap: (){
                                              printTicket().then((value) {
                                                if(value == "OK"){
                                                  context.read<GeneralNotifier>().bluetoothPrinterMacId = d.remoteId.toString();
                                                  showAwesomeDialogue(title: "Success", content: "Your printer is ready to use", type: DialogType.success);
                                                }
                                              });
                                            }, title: "Test Print"
                                        );
                                      }
                                      if (snapshot.data == BluetoothConnectionState.disconnected) {
                                        return CustomButton(
                                            height: 50.h,
                                            width: 110.w,
                                            onTap: (){
                                          isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(true);
                                          isConnectingOrDisconnecting[d.remoteId]!.value = true;
                                          d.connect(timeout: Duration(seconds: 35)).catchError((e) {
                                            final snackBar = snackBarFail(prettyException("Connect Error:", e));
                                            snackBarKeyC.currentState?.removeCurrentSnackBar();
                                            snackBarKeyC.currentState?.showSnackBar(snackBar);
                                          }).then((v) {
                                            isConnectingOrDisconnecting[d.remoteId] ??= ValueNotifier(false);
                                            isConnectingOrDisconnecting[d.remoteId]!.value = false;
                                            setState(() {
                                              name = d.localName;
                                            });
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) =>PrintIII(mac:d.remoteId.toString(),title: "Preview",)));

                                            setConnect(d.remoteId.toString()).then((value) {
                                              printTicket().then((value) {
                                                if(value == "OK"){
                                                  context.read<GeneralNotifier>().bluetoothPrinterMacId = d.remoteId.toString();
                                                  showAwesomeDialogue(title: "Success", content: "Your printer is ready to use", type: DialogType.success);
                                                }
                                              });
                                            });
                                            // setConnect(d.remoteId.toString()).then((value) {
                                            //
                                            //   Navigator.push(context, MaterialPageRoute(builder: (context) =>PrintIII(mac:d.remoteId.toString() ,title: "Preview",)));
                                            //
                                            // });
                                          });
                                        }, title: "Connect"
                                         );
                                      }
                                      return Text(snapshot.data.toString().toUpperCase().split('.')[1],style: getSemiBoldStyle(color: Colors.black),);
                                    },
                                  ),
                                ))
                                    .toList(),
                              ),
                            ),
                kDivider,
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: (snapshot.data ?? []).map((r) => ScanResultTile(
                        result: r,
                        isConnect: false,
                        onTap: (){
                          isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(true);
                          isConnectingOrDisconnecting[r.device.remoteId]!.value = true;
                          r.device.connect(timeout: Duration(seconds: 35)).catchError((e) {
                            final snackBar = snackBarFail(prettyException("Connect Error:", e));
                            snackBarKeyC.currentState?.removeCurrentSnackBar();
                            snackBarKeyC.currentState?.showSnackBar(snackBar);
                          }).then((v) {
                            isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(false);
                            isConnectingOrDisconnecting[r.device.remoteId]!.value = false;
                            setState(() {
                              name = r.device.localName;
                            });
                            setConnect(r.device.remoteId.toString()).then((value) {

                              printTicket().then((value) {
                                if(value == "OK"){
                                  context.read<GeneralNotifier>().bluetoothPrinterMacId = r.device.remoteId.toString();
                                  showAwesomeDialogue(title: "Success", content: "Your printer is ready to use", type: DialogType.success);
                                }
                              });
                            });
                            // setConnect(r.device.remoteId.toString()).then((value) {
                            //
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) =>PrintIII(mac:r.device.remoteId.toString() ,title: "Preview",)));
                            //
                            // });
                          });


                        }
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBluePlus.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data ?? false) {
              return FloatingActionButton(

                foregroundColor: ColorManager.white,
                child: const Icon(Icons.stop),
                onPressed: () async {
                  try {
                    FlutterBluePlus.stopScan();
                  } catch (e) {
                    final snackBar = snackBarFail(prettyException("Stop Scan Error:", e));
                    snackBarKeyB.currentState?.removeCurrentSnackBar();
                    snackBarKeyB.currentState?.showSnackBar(snackBar);
                  }
                },
                backgroundColor: ColorManager.onPrimaryLight,
              );
            } else {
              return FloatingActionButton(
                  child: const Text("SCAN"),
                  foregroundColor: ColorManager.white,

                  onPressed: () async {
                    try {
                      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
                    } catch (e) {
                      final snackBar = snackBarFail(prettyException("Start Scan Error:", e));
                      snackBarKeyB.currentState?.removeCurrentSnackBar();
                      snackBarKeyB.currentState?.showSnackBar(snackBar);
                    }
                    setState(() {}); // force refresh of connectedSystemDevices
                  });
            }
          },
        ),
      ),
    );
  }
}


String prettyException(String prefix, dynamic e) {
  if (e is FlutterBluePlusException) {
    return "$prefix ${e.description}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}

///
///
///
class PrintIII extends StatefulWidget {
  const PrintIII({Key? key, required this.title,required this.mac}) : super(key: key);
  final String title;
  final String mac;

  @override
  State<PrintIII> createState() => _PrintIIIState();
}

class _PrintIIIState extends State<PrintIII> {
  ScreenshotController screenshotController = ScreenshotController();
  String dir = Directory.current.path;
  bool connected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(dir);
    // this func to cheeck if port are close or not
    // setConnect(widget.mac);
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");
    if (result == "true") {
      setState(() {
        connected = true;
      });
    }
  }

  Future<List<int>> getTicket(Uint8List theimageThatComesfr) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    // bytes += generator.text("Demo Shop1",
    //     styles: PosStyles(
    //       align: PosAlign.center,
    //       height: PosTextSize.size3,
    //       width: PosTextSize.size3,
    //     ),
    //   );
    final im.Image? image = im.decodeImage(theimageThatComesfr);
    // bytes += generator.image(image!);
    bytes += generator.imageRaster(image!,align: PosAlign.center);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> printTicket(Uint8List theimageThatComesfr) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket(theimageThatComesfr);
      final result = await  BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      //Hadnle Not Connected Senario
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("معاينة الوصل قبل الطباعة "),
      ),
      body: Center(
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      'print res',
                      style: TextStyle(fontSize: 40),
                    ),
                    onPressed:connected ?  () {
                      screenshotController
                          .capture(delay: Duration(milliseconds: 10))
                          .then((capturedImage) async {
                         Uint8List theimageThatComesfromThePrinter = capturedImage!;
                        setState(() {
                          theimageThatComesfromThePrinter = capturedImage;
                          theimageThatComesfromThePrinter.isNotEmpty ?  showSnackBar(context: context, text: "image is taken ${theimageThatComesfromThePrinter.length}") : null;
                          printTicket(theimageThatComesfromThePrinter);
                        });
                      }).catchError((onError) {
                        print(onError);
                      });
                    }:null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: ColorManager.white,
                          width: 190,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text("Al Khair Demo",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s18),textAlign: TextAlign.center,)),
                              kSizedBox10,
                              Center(child: Text("Tax Invoice/فاتورة ضريبية",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s14),textAlign: TextAlign.center,)),
                              kSizedBox20,
                              Text("al Jubail, Saudi arabia",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize:FontSize.s9),),
                              Text("الجبيل ,السعودية",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              Text("VAT: 33392938343922",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              Text("CRN: 233929383922",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              MySeparator(color: ColorManager.black),
                              Text("Rohshan Shop",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize:FontSize.s9),),
                              Text("متجر روشان",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize:FontSize.s9),),
                              Text("shihat, dammam Saudi Arabia",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              Text("شيهات, الدمام السعودية",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize:FontSize.s9,)),
                              Text("VAT: 323233222334432",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              Text("CRN: 232119302",style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s9),),
                              MySeparator(color: ColorManager.black,isDouble: true,),

                              Container(
                                // padding: EdgeInsets.symmetric(horizontal:AppPadding.p16),
                                child: Table(

                                  children: <TableRow>[
                                    TableRow(
                                      children: < Widget>[
                                        Text(
                                            'فاتورة',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'تاريخ',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'وقت',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'قسط',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10,),
                                            textAlign: TextAlign.center

                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: < Widget>[
                                        Text(
                                            'Invoice',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'Date',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'Time',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'Payment',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10,),
                                            textAlign: TextAlign.center

                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        MySeparator(color: ColorManager.black),
                                       MySeparator(color: ColorManager.black),
                                       MySeparator(color: ColorManager.black),
                                       MySeparator(color: ColorManager.black),
                                      ],
                                    ),

                                    TableRow(
                                      children: < Widget>[
                                        Text(
                                            "SLV 909",
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),

                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            '03-09-2023',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            '09:23 PM',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                            textAlign: TextAlign.center
                                        ),
                                        Text(
                                            'Cash',
                                            style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                            textAlign: TextAlign.center
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              kSizedBox10,
                              Container(
                                // padding: EdgeInsets.symmetric(horizontal:AppPadding.p16),
                                child: Column(
                                  children: [
                                    Row(

                                      children: [
                                                  SizedBox(
                                                    width:23.33,
                                                    child: Text(
                                                        'غرض',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'الكمية',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'وحدة',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'القرص',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'سعر',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'الفرعية',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                      ],
                                    ),
                                    Row(

                                      children: [
                                                  SizedBox(
                                                    width:23.33,
                                                    child: Text(
                                                        'Item',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'QTY',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'Unit',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'Disc.',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'Rate',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 33.33,
                                                    child: Text(
                                                        'SUB',
                                                        style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                                        textAlign: TextAlign.center
                                                    ),
                                                  ),
                                      ],
                                    ),
                                    MySeparator(color: ColorManager.black),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width:188,
                                          child: Text(
                                              'Madhfoon Chiken with rice',
                                              style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                              textAlign: TextAlign.left
                                          ),
                                        ),
                                        SizedBox(
                                          width:188,
                                          child: Text(
                                              'دجاج مدفون مع الأرز',
                                              style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                              textAlign: TextAlign.left
                                          ),
                                        ),
                                        Row(

                                          children: [
                                            SizedBox(
                                              width:23.33,
                                              child: Text(
                                                  '',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '22',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  'KG',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '0.00',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '1.00',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '22',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            )

                                          ],
                                        ),

                                      ],
                                    ),
                                    kSizedBox2,
                                    Column(
                                      children: [
                                        SizedBox(
                                          width:188,
                                          child: Text(
                                              'Kabsa rise with alfaham',
                                              style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                              textAlign: TextAlign.left
                                          ),
                                        ),
                                        SizedBox(
                                          width:188,
                                          child: Text(
                                              'كبسة ترتفع مع الفحام',
                                              style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                              textAlign: TextAlign.left
                                          ),
                                        ),
                                        Row(

                                          children: [
                                            SizedBox(
                                              width:33.33,
                                              child: Text(
                                                  '',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 23.33,
                                              child: Text(
                                                  '22',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  'KG',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '0.00',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),

                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '1.00',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            ),
                                            SizedBox(
                                              width: 33.33,
                                              child: Text(
                                                  '22',
                                                  style: getBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s8),
                                                  textAlign: TextAlign.center
                                              ),
                                            )

                                          ],
                                        ),

                                      ],
                                    ),
                                    kSizedBox2,



                                  ],
                                )
                              ),
                              MySeparator(color: ColorManager.black,isDouble: true,),
                              ///sub total area
                              Align(
                                alignment: Alignment.centerRight,
                                child:    Container(
                                  // padding: EdgeInsets.all(AppPadding.p16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Subtotal
                                      Text(
                                          'Subtotal / المجموع الفرعي (SAR): 493.00',
                                          style: getSemiBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                          textAlign: TextAlign.center
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                          'Discount / تخفيض (SAR): 493.00',
                                          style: getSemiBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                          textAlign: TextAlign.center
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                          'VAT / ضريبة القيمة المضافة (SAR): 493.00',
                                          style: getSemiBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                          textAlign: TextAlign.center
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                          'Net Due / صافي نتيجة (SAR): 493.00',
                                          style: getSemiBoldInvoiceStyle(color: ColorManager.black,fontSize: FontSize.s10),
                                          textAlign: TextAlign.center
                                      ),
                                      SizedBox(height: 5),

                                    ],
                                  ),
                                ),
                              ),


                            ]
                          ),

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
// [
// Text(
// 'فف عغب عه',
// style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// SizedBox(height: 8),
// Text(
// 'ثخلنرس ثبة ثب',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// SizedBox(height: 16),
// Text(
// 'ينخبخ ينبة ينني',
// style: TextStyle(fontSize: 16,color: ColorManager.black)
// ),
// SizedBox(height: 8),
// Text(
// 'VAT: Your Company VAT',
// style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// Text(
// 'CRN: Your Company CRN',
// style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
//const MySeparator(color: ColorManager.black),
// Text(
// 'سخين ييخس',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// Text(
// 'ينءنش يخسحسا لا',
// style: TextStyle(fontSize: 16,color: ColorManager.black)
// ),
// Text(
// 'CRN: سرر صلقس',
// style: TextStyle(fontSize: 16,color: ColorManager.black),
// ),
// Text(
// 'VAT: لسق ثف ',
// style: TextStyle(fontSize: 16,color: ColorManager.black),
// ),
//const MySeparator(color: ColorManager.black),
// Text(
// 'قثصق ',
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// SizedBox(height: 8),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('Invoice Date:', style: TextStyle(fontSize: 16,color: ColorManager.black)),
// Text('2023-10-05', style: TextStyle(fontSize: 16,color: ColorManager.black)),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('ثبس ثصب', style: TextStyle(fontSize: 16,color: ColorManager.black)),
// Text('CASH', style: TextStyle(fontSize: 16,color: ColorManager.black)),
// ],
// ),
// // ... Add more invoice details as needed
//const MySeparator(color: ColorManager.black),
// Text(
// 'بقب ',
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('ثقب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// Text('ثب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// Text('بثب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// Text('ثبس', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// Text('سثب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// Text('سبث', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: ColorManager.black)),
// ],
// ),
//const MySeparator(color: ColorManager.black),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('سثبي ب', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// Text('2', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// Text('يسب', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// Text('0.50', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// Text('10.00', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// Text('20.00', style: TextStyle(fontSize: 14,color: ColorManager.black)),
// ],
// ),
//const MySeparator(color: ColorManager.black),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('يسبيس (SAR):', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// Text('200.00', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('سبي (SAR):', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// Text('10.00', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('سبسي  (SAR):', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// Text('15.00', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// ],
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text('سيبسي بث (SAR):',style: TextStyle(fontSize: 8,color: ColorManager.black)),
// Text('205.00', style: TextStyle(fontSize: 8,color: ColorManager.black)),
// ],
// ),
//const MySeparator(color: ColorManager.black),
// Text(
// 'Tتعر تاارر ارا',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: ColorManager.black),
// ),
// SizedBox(height: 8),
// Text(
// 'POWERED BY KENZ TECHNOLOGY\nwww.kenztechnology.com\n+966 53 903 6749',
// style: TextStyle(fontSize: 14,color: ColorManager.black),
// textAlign: TextAlign.center
// ),
// ],