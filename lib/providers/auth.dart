import 'dart:developer';

import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;

  bool get autheticated => _authenticated;

  void login({required Map credentials}) {
    _authenticated = true;

    log("HERE");

    notifyListeners();
  }
}
