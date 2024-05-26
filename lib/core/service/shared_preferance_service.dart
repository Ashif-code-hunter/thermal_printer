import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/string_manager.dart';


class CacheService {
  static final CacheService _singleton = CacheService._internal();

  factory CacheService() {
    return _singleton;
  }
  CacheService._internal();

  Future readCache({required String key}) {
    const FlutterSecureStorage sharedPreferences = FlutterSecureStorage();
    var cache = sharedPreferences.read(key: key);
    return cache;
  }

  Future writeCache({required String key, required String value}) async {
    const FlutterSecureStorage sharedPreferences = FlutterSecureStorage();
    await sharedPreferences.write(key: key, value: value);
  }

  Future deleteCache({String? key}) async {
    FlutterSecureStorage sharedPreferences = const FlutterSecureStorage();
    await sharedPreferences.delete(key: key ?? AppStrings.token);
  }

  Future deleteSignUpCache() async {
    FlutterSecureStorage sharedPreferences = const FlutterSecureStorage();
    await sharedPreferences.delete(key:AppStrings.token);
    await sharedPreferences.delete(key:AppStrings.displayName);
    await sharedPreferences.delete(key:AppStrings.mobileBatch);
    await sharedPreferences.delete(key:AppStrings.userName);
    await sharedPreferences.delete(key:AppStrings.email);
    await sharedPreferences.delete(key:AppStrings.sysUserId);
    await sharedPreferences.delete(key:AppStrings.locationCode);
    }
}