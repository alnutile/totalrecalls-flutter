import 'dart:convert';
import 'dart:developer';
// import 'dart:ffi';

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
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "These are all your notifications related to topics you are subscribed to.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'You can find there later if needed.')),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: Text(watchText(item.watch)),
                                        onPressed: () {
                                          watch(item.id);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'These items are in your Watched area')),
                                          );
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
            ],
          ),
        ));
  }
}
