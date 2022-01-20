import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalrecalls/main.dart';
import 'package:totalrecalls/providers/auth.dart';
import 'package:totalrecalls/screen/login-screen.dart';
import 'package:totalrecalls/screen/notificaitons-screen%20.dart';
import 'package:totalrecalls/screen/register.dart';
import 'package:totalrecalls/screen/subscribe-screen.dart';
import 'package:totalrecalls/screen/add-subscription-screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          if (auth.authenticated) {
            return ListView(
              children: [
                ListTile(
                  title: Text("Welcome " + auth.user.name),
                ),
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
                  title: Text("Recall Topics Subscribe Here!"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSubscriptionScreen()));
                  },
                ),
                ListTile(
                  title: Text("Logout"),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )
              ],
            );
          } else {
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
                  title: Text("Register"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  },
                ),
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
