import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';

import '../dio.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;

  bool get autheticated => _authenticated;

  Future login({required Map credentials}) async {
    Dio.Response response = await dio().post(
      'token',
      data: json.encode(credentials),
    );

    String token = json.decode(response.toString())['token'];

    log(token);

    _authenticated = true;

    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    log("HERE");

    notifyListeners();
  }
}
