import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationsState();
  }
}

class NotificationsState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read Notififications"),
      ),
      body: Center(
        child: Text("Your Notifications"),
      ),
    );
  }
}
