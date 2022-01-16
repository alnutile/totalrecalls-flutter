import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalrecalls/main.dart';
import 'package:totalrecalls/providers/auth.dart';
import 'package:totalrecalls/screen/login-screen.dart';
import 'package:totalrecalls/screen/notificaitons-screen%20.dart';
import 'package:totalrecalls/screen/subscribe-screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          if (auth.autheticated) {
            return ListView(
              children: [
                ListTile(
                  title: Text("Home"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: 'TotalRecalls.io')));
                  },
                ),
                ListTile(
                  title: Text("Your Notifications"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsScreen()));
                  },
                ),
                ListTile(
                  title: Text("Your Subscriptions"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscribeScreen()));
                  },
                ),
                ListTile(
                  title: Text("Logout"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            );
          } else {
            return ListView(
              children: [
                ListTile(
                  title: Text("Login"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }
}
