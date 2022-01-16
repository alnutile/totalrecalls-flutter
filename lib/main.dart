import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalrecalls/providers/auth.dart';
import 'package:totalrecalls/widgets/nav-drawer.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => Auth(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TotalRecalls.io',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TotalRecalls.io'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (auth.autheticated) {
              return Text("You are logged in");
            } else {
              return Text("You are NOT logged in");
            }
          },
        ),
      ),
    );
  }
}
