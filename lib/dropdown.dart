import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'MyWebView.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'dart:io';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'One';
  String token;
  final storage = new FlutterSecureStorage();

void getInit() async {
    token = await storage.read(key: "token");
    print(token);
  }

@override
  void initState() {
    super.initState();
    this.getInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
  child: Text("Open Webpage"),
  onPressed: () {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MyWebView(
              title: "Documents",
              selectedUrl: "http://localhost:50051/v1/public/user/getFile/5e2b22ba9f6e45bb9ef3c40e",
            )));
  },
),
    ));
  }
}

