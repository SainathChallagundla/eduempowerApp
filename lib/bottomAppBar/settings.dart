import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.email}) : super(key: key);
  final String email;

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Settings")),
      body: Container(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[]),
          )),
    );
  }
}
