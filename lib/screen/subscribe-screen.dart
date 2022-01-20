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
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "You can unsubscribe here and easily re-subscribe",
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Unsubscribed! You can subscribe again anytime.')),
                                          );
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
          ],
        ),
      ),
    );
  }
}
