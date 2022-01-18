import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

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
  String watchText(int watch) {
    if (watch == 1) {
      return "Un-Watch";
    }
    return "Watch";
  }

  String getTitle(String title) {
    var max = 75;
    if (title.length < max) {
      return title;
    }

    return title.replaceRange(max, title.length, '...');
  }

  markRead(int recallId) async {
    Dio.Response response = await dio().post("mynotifications/read",
        options: Dio.Options(
          headers: {'auth': true},
        ),
        data: [recallId]);

    try {
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  watch(int recallId) async {
    log(recallId.toString());
    Dio.Response response = await dio().post("mynotifications/watch",
        options: Dio.Options(
          headers: {'auth': true},
        ),
        data: [recallId]);

    try {
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<RecallNotification>> getNotifications() async {
    Dio.Response response = await dio().get(
      "mynotifications",
      options: Dio.Options(
        headers: {'auth': true},
      ),
    );

    var data = json.decode(response.data.toString())['data']['notifications'];

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
                  return Center(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(getTitle(item.title)),
                            subtitle: Text(item.body),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Mark Read'),
                                onPressed: () {
                                  markRead(item.id);
                                },
                              ),
                              TextButton(
                                child: Text(watchText(item.watch)),
                                onPressed: () {
                                  watch(item.id);
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
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
