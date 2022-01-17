import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import '../dio.dart';
import 'package:totalrecalls/models/recallNotification.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationsState();
  }
}

class NotificationsState extends State<NotificationsScreen> {
  Future<List<RecallNotification>> getNotifications() async {
    Dio.Response response = await dio().get(
      "mynotifications",
      options: Dio.Options(
        headers: {'auth': true},
      ),
    );

    var data = json.decode(response.data.toString())['data']['notifications'];

    log(data.toString());

    List recallNotifications = data;

    return recallNotifications
        .map((notice) => RecallNotification.fromJson(notice))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read Notififications"),
      ),
      body: Center(
        child: FutureBuilder<List<RecallNotification>>(
          future: getNotifications(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return ListView.builder(
                itemCount: snapShot.data?.length,
                itemBuilder: (context, index) {
                  var item = snapShot.data![index];

                  return ListTile(
                    title: Text(item.title),
                  );
                },
              );
            } else if (snapShot.hasError) {
              log(snapShot.error.toString());
              return Text("Failed to get Notifications");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
