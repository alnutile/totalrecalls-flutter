import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubscribeState();
  }
}

class SubscribeState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Subscriptions"),
      ),
      body: Center(
        child: Text("Your Subscriptions"),
      ),
    );
  }
}
