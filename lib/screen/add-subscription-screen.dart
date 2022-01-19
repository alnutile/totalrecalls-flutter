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

  List topics = [
    "city",
    "country",
    "company",
    "level",
    "state",
  ];

  String filter = "";

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
    List searchFilters = [];

    if (filter != "") {
      searchFilters.add("type=" + filter);
    }

    if (search != "") {
      searchFilters.add("search=" + search);
    }

    if (searchFilters.isEmpty) {
      return "";
    }

    return "?" + searchFilters.join("&");
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

  var _isSelected = false;

  _buildChip(String label, Color color) {
    return InputChip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      selected: filter == label,
      onSelected: (bool selected) {
        if (filter == label) {
          filter = "";
        } else {
          filter = label;
        }
        getSubscibables();
        setState(() {});
      },
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
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
            Container(
              child: Wrap(spacing: 6.0, runSpacing: 6.0, children: [
                ...(topics).map((topic) {
                  return _buildChip(topic, Colors.black54);
                }).toList(),
              ]),
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
