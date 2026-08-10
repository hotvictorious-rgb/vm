import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_delivery_boy/data/api/api_client.dart';
import 'package:sixvalley_delivery_boy/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';


class AuthRepository implements AuthRepositoryInterface{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  AuthRepository({required this.apiClient, required this.sharedPreferences, required this.secureStorage});

  @override
  Future<Response> login(String countryCode, String phone, String password) async {
    return await apiClient.postData(AppConstants.loginUri,
        {"country_code": '+'+countryCode ,"phone": phone, "password": password});
  }

  @override
  Future<Response> setLanguageCode(String languageCode) async {
    return await apiClient.postData(AppConstants.setCurrentLanguageUri,
        {"current_language": languageCode, '_method' : 'put' });
  }


  @override
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.languageCode));
    // Store token securely in encrypted storage
    await secureStorage.write(key: AppConstants.token, value: token);
    // Keep SharedPreferences in sync for backward compatibility
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  Future<Response> updateToken() async {
    String? _deviceToken;
    if (GetPlatform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
        debugPrint('=========>Device Token ======$_deviceToken');
      }
    }else {
      _deviceToken = await _saveDeviceToken();
      debugPrint('=========>Device Token ======$_deviceToken');
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic('six_valley_delivery');
    }

    // Read token from secure storage first, fall back to SharedPreferences
    String? authToken = await secureStorage.read(key: AppConstants.token);
    authToken ??= sharedPreferences.getString(AppConstants.token);

    return await apiClient.postData(AppConstants.tokenUri,

        {"_method": "put", "fcm_token": _deviceToken},
      headers:  {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken'
      },
    );
  }


  Future<String?> _saveDeviceToken() async {
    String? _deviceToken = '';
    if(!GetPlatform.isWeb) {
      _deviceToken = await (FirebaseMessaging.instance.getToken());
    }
    return _deviceToken;
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  Future<bool> clearSharedData() async {
    if(!GetPlatform.isWeb) {
      apiClient.postData(AppConstants.tokenUri, {"_method": "put", "fcm_token": 'no'});
    }
    // Clear token from both secure storage and SharedPreferences
    await secureStorage.delete(key: AppConstants.token);
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  @override
  Future<void> saveUserCredentials(String countryCode, String number, String password) async {
    try {
      // Store credentials securely in encrypted storage
      await secureStorage.write(key: AppConstants.userPassword, value: password);
      await secureStorage.write(key: AppConstants.userEmail, value: number);
      await secureStorage.write(key: AppConstants.userCountryCode, value: countryCode);
      // Keep SharedPreferences in sync for non-sensitive read access
      await sharedPreferences.setString(AppConstants.userEmail, number);
      await sharedPreferences.setString(AppConstants.userCountryCode, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.userEmail) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }



  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<bool> clearUserEmailAndPassword() async {
    await secureStorage.delete(key: AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userEmail);
  }


  @override
  Future<bool> clearUserCredentials() async{
    await secureStorage.delete(key: AppConstants.userPassword);
    await secureStorage.delete(key: AppConstants.userCountryCode);
    await secureStorage.delete(key: AppConstants.userEmail);
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userEmail);
  }

  @override
  Future<Response> forgotPassword(String? countryCode ,String? phone) async {
    Response _response = await apiClient.postData(AppConstants.forgotPassword,
        {
          'country_code' : countryCode,
          'phone': phone
        });
    return _response;
  }

  @override
  Future<Response> verifyOtp(String countryCode ,String? phone) async {
    Response _response = await apiClient.postData(AppConstants.verifyOtp,
        {
          'otp' : countryCode,
          'phone': phone
        });
    return _response;
  }

  @override
  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

}

