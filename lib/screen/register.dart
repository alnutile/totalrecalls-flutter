import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:totalrecalls/models/subscription.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:webview_flutter/webview_flutter.dart';
import '../dio.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: WebView(
        initialUrl: "https://totalrecalls.io/register",
      ),
    );
  }
}
