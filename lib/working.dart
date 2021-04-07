import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MyWebView.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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
          if (kIsWeb) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MyWebView(
                      title: "Documents",
                      selectedUrl:
                          "http://localhost:50051/v1/public/user/getFile/5e2b22ba9f6e45bb9ef3c40e",
                    )));
          } else if (Platform.isAndroid || Platform.isIOS) {
            print("------>url Launcher<-------");
            _launchInBrowser(
                "http://localhost:50051/v1/public/user/getFile/5e2b22ba9f6e45bb9ef3c40e");
          }
        },
      ),
      /* ListTile(
  title: Text("Launch Web Page"),
  onTap: () async {
    const url = 'http://localhost:50051/v1/public/user/getFile/5e2b22ba9f6e45bb9ef3c40e';

    if (await canLaunch(url)) {
      print("----->"+token);
      await launch(url,enableDomStorage: true, universalLinksOnly:true,forceSafariVC: true, headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    } else {
      throw 'Could not launch $url';
    }
  },
),*/
    ));
  }
}

Future<void> _launchInBrowser(String url) async {
  await launch(
    url,
    forceSafariVC: true,
    forceWebView: true,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  );
}
