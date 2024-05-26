import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/provider/providers.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

import 'constants/app_routes.dart';
import 'constants/theme_manager.dart';

//delete this whenever you got context idea
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




    @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        return ScreenUtilInit(
          designSize: const Size(360, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_,k) => OverlaySupport(
            child: MaterialApp(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: snackbarKey,
              theme: getApplicationTheme(),
              debugShowCheckedModeBanner: false,
              routes: routes,
              initialRoute: invoicePrintingScreen,
              // initialRoute:invoicePrintingScreen,
            ),
          ),
        );
      }),
    );
  }
}


