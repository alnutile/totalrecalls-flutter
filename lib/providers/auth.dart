import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:totalrecalls/models/user.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dio.dart';

class Auth extends ChangeNotifier {
  final storage = FlutterSecureStorage();

  bool _authenticated = false;
  User _user = User(id: 0, email: "not@set.com", name: "empty");

  bool get authenticated => _authenticated;
  User get user => _user;

  Future login({required Map credentials}) async {
    String deviceId = await getDeviceId();

    Dio.Response response = await dio().post(
      'token',
      data: json.encode(credentials..addAll({'deviceId': deviceId})),
    );
    String token = json.decode(response.toString())['token'];
    await attempt(token);
    storeToken(token);

    notifyListeners();
  }

  deleteToken() async {
    await storage.delete(key: "auth");
  }

  storeToken(String token) async {
    await storage.write(key: 'auth', value: token);
  }

  Future getToken() async {
    return await storage.read(key: 'auth');
  }

  Future attempt(String token) async {
    try {
      Dio.Response response = await dio().get(
        "user",
        options: Dio.Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      _user = User.fromJson(json.decode(response.toString()));
      _authenticated = true;
    } catch (e) {
      _authenticated = false;
      log("ERROR with auth");
      log(e.toString());
    }
  }

  Future getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  void logout() async {
    _authenticated = false;

    await dio().delete(
      "token",
      options: Dio.Options(
        headers: {'auth': true},
      ),
    );

    await deleteToken();

    notifyListeners();
  }
}
