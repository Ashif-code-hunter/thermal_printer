import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/constants.dart';
import 'package:untitled/constants/string_manager.dart';

import '../constants/service/shared_preferance_service.dart';

class GeneralNotifier extends ChangeNotifier {
  int _axisCount = 2;

  String? _userName;
  String? _sysUserID;
  String? _locationCode;
  String? _mobileBatch;
  String? _email;
  String? _displayName;
  String? _ip;
  double _percent =0.00;
  bool _loginOnceMore = true;
  String? _bluetoothPrinterMacId;

  double? get getPercent => _percent;
  bool? get getLoginBool=> _loginOnceMore;
  int get getAxisCount => _axisCount;
  String? get getUserName => _userName;
  String? get getIP => _ip;
  String? get getSysUserID => _sysUserID;
  String? get getBluetoothPrinterMacID => _bluetoothPrinterMacId;
  String? get getLocationCode => _locationCode;
  String? get getMobileBatch => _mobileBatch;
  String? get getEmail => _email;
  String? get getDisplay => _displayName;
  CacheService cashService = CacheService();


  void   setPercent(double per){
    _percent = per ;
    notifyListeners();
  }


  Future<void> checkAxisCount({required BuildContext context}) async {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      _axisCount = 6;
    } else if (screenWidth > 1000) {
      _axisCount = 4;
    } else if (screenWidth > 800) {
      _axisCount = 4;
    } else if (screenWidth > 600) {
      _axisCount = 3;
    } else {
      _axisCount = 2;
    }
    notifyListeners();
  }

  Future<void> getUserNameFun() async {
    _userName = await cashService.readCache(key: AppStrings.userName);
    _displayName = await cashService.readCache(key: AppStrings.displayName);
    _email = await cashService.readCache(key: AppStrings.email);
    _sysUserID = await cashService.readCache(key: AppStrings.sysUserId);
    _locationCode = await cashService.readCache(key: AppStrings.locationCode);
    _mobileBatch = await cashService.readCache(key: AppStrings.mobileBatch);
    notifyListeners();
  }

  Future<void> deleteIp({required String ip}) async {
    await cashService.deleteCache(key:  AppStrings.ipAddress,);
  }

  Future<void> setIp({required String ip}) async {
    await cashService.writeCache(key:  AppStrings.ipAddress, value:ip);
  }



  set bluetoothPrinterMacId(String macID){
    _bluetoothPrinterMacId = macID;
    notifyListeners();
  }

  Future<void> setTimer() async {

      _loginOnceMore = false;
      notifyListeners();
      Future.delayed(const Duration(minutes: 5), () {
        _loginOnceMore = true;
        notifyListeners();
      });


  }

  Future<void> setLoader() async {
    _percent = 0;
    notifyListeners();



    const totalMessages = 100;
    const totalTimeInSeconds = 2 * 60;
    final interval = Duration(milliseconds: (totalTimeInSeconds / totalMessages * 1000).round());

    Timer.periodic(interval, (timer) {
      _percent++;
      notifyListeners();
      if (_percent >= totalMessages) {
        timer.cancel();
      }
    });

  }
}
