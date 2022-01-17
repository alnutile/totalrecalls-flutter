import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:totalrecalls/models/subscription.dart';

import 'package:dio/dio.dart' as Dio;
import '../dio.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SubscribeState();
  }
}

class SubscribeState extends State<SubscribeScreen> {
  unsubscribe(int subId) async {
    Dio.Response response = await dio().post("mysubscriptions",
        options: Dio.Options(
          headers: {'auth': true},
        ),
        data: [subId]);

    try {
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Subscription>> getSubscriptions() async {
    Dio.Response response = await dio().get(
      "mysubscriptions",
      options: Dio.Options(
        headers: {'auth': true},
      ),
    );

    var data = json.decode(response.data.toString());

    List subscriptions = data;

    return subscriptions
        .map((notice) => Subscription.fromJson(notice))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Subscriptions"),
      ),
      body: Center(
        child: FutureBuilder<List<Subscription>>(
          future: getSubscriptions(),
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
                            ListTile(title: Text(item.name)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text("Unsubscribe"),
                                  onPressed: () {
                                    unsubscribe(item.id);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Text("No Subscriptions? Choose some below");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
