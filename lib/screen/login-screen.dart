import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:totalrecalls/providers/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void submit() async {
    Provider.of<Auth>(context, listen: false)
        .login(credentials: {'email': _email, 'password': _password});

    Navigator.pop(context);
  }

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Email", hintText: "you@somewhere.com"),
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          )),
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      // This was supposed to be FlatButton
                      child: FlatButton(
                        child: Text("Login"),
                        onPressed: () {
                          _formKey.currentState!.save();
                          this.submit();
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
