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
  TextEditingController editingController = TextEditingController();

  String search = "";

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

  String searchString() {
    if (search == "") {
      return "";
    }

    return "?search=" + search;
  }

  Future<List<Subscribable>> getSubscibables() async {
    log("subscribables" + searchString());

    Dio.Response response = await dio().get(
      "subscribables" + searchString(),
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
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  if (value.length > 2) {
                    search = value;
                    log("refresh subscribables");
                    getSubscibables();
                    setState(() {});
                  }
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      search = "";
                      editingController.clear();
                      getSubscibables();
                      setState(() {});
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
            ),
            Expanded(
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Added to Subscriptions')),
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
                    return Text("Failed to get Subscribable Topics");
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
