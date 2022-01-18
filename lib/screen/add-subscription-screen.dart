import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:totalrecalls/models/subscibable.dart';
import '../dio.dart';

class AddSubscriptionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSubscriptionState();
  }
}

class AddSubscriptionState extends State<AddSubscriptionScreen> {
  subscribe(int subId) async {
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

  Future<List<Subscribable>> getSubscibables() async {
    Dio.Response response = await dio().get(
      "subscribables",
      options: Dio.Options(
        headers: {'auth': true},
      ),
    );

    var data = json.decode(response.data.toString());

    List subscribables = data;

    return subscribables
        .map((notice) => Subscribable.fromJson(notice))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscribe to Recall Topics"),
      ),
      body: Center(
        child: FutureBuilder<List<Subscribable>>(
          future: getSubscibables(),
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
                            title: Text(item.name),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: Text("Subscribe"),
                                onPressed: () {
                                  subscribe(item.id);
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
              return Text("Failed to get Notifications");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
