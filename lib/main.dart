import 'package:eduempower/public/register.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/public/login.dart';
import 'package:eduempower/home.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//void main() => runApp(MyApp());
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final storage = new FlutterSecureStorage();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Set default home.
  Widget _defaultHome = new UserLogin();

  // String _result = await storage.read(key: "token");

  String _result = prefs.getString("token");
  print("===============TOKEN====================$_result");

  if (_result != null) {
    _defaultHome = new HomePage(
      title: "Edu EmPower",
    );
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    theme: new ThemeData(
        primaryColor: Colors.orange[300], //const //Color(0xFF02BB9F),
        primaryColorDark: Colors.orange[500], //const Color(0xFF167F67),
        accentColor: Colors.orange[200] //const Color(0xFFFFAD32),
        ),
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(),
      '/login': (BuildContext context) => new UserLogin(),
      '/register': (BuildContext context) => new UserRegister()
    },
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        /*home: Scaffold(
        appBar: AppBar(
          title: Text("Edu EM--->Power")
        ),
       // body: MyCustomForm(),
      ),*/
        home: UserLogin()
        //  body: MyCustomForm()
        );
  }
}
