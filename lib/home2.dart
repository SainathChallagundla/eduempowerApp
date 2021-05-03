import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/drawer/individual.dart';
import 'package:eduempower/drawer/organization.dart';
import 'package:eduempower/dropdown.dart';
import 'package:eduempower/public/login.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/summary.dart';

class MyHomePage extends StatefulWidget {
  String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
  MyHomePage({Key key, this.title}) : super(key: key);
}

class _MyHomePageState extends State<MyHomePage> {
  String token, email, name, userType, userCategory;
  final mainKey = GlobalKey<ScaffoldState>();
  Summary summary = Summary();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    var _summary = await HttpHelper()
        .getSummary(HttpEndPoints.BASE_URL + HttpEndPoints.GET_SUMMARY, token);
    setState(() {
      summary = _summary;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edu Empower",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Logofont',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            slotCard("Total Beneficiaries : ", summary.noofBenificiaries),
            slotCard("No Of Donors :", summary.noofDonars),
            slotCard("Number of Contributors : ", summary.noofContributors),
            slotCard("Funds Collected:", summary.fundsCollected),
            slotCard("Funds Contributed:", summary.fundsContributed),
          ],
        ),
      ),
      drawer: _drawer(context),
    );
  }

  Card slotCard(String title, num trailing) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.orange[300],
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              "$title",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            trailing: Text(
              "$trailing",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text("Edu Empower",
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Logofont',
                                fontWeight: FontWeight.bold,
                                fontSize: 20)))),
                SizedBox(height: 5),
                Text('Hello $name'),
                SizedBox(height: 5),
                Text('Registered Email: $email'),
                SizedBox(height: 5),
                OutlineButton(
                  child: Text("Edit Profile"),
                  onPressed: () {
                    Navigator.pop(context);
                    if (userType == "individual") {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  IndividualPage()))
                          .then((value) {
                        if (value == true) {
                          mainKey.currentState.showSnackBar(new SnackBar(
                              content: Text("User Profile Updation Successful"),
                              duration: Duration(milliseconds: 1000)));
                        } else if (value == false) {
                          mainKey.currentState.showSnackBar(new SnackBar(
                              content: Text("User Profile Updation Failed"),
                              duration: Duration(milliseconds: 1000)));
                        } else {}
                        // Run the code here using the value
                      });
                    } else if (userType == "organization") {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OrganizationPage()))
                          .then((value) {
                        if (value == true) {
                          mainKey.currentState.showSnackBar(new SnackBar(
                              content: Text(
                                  "Organization User Profile Updation Successful"),
                              duration: Duration(milliseconds: 1000)));
                        } else if (value == false) {
                          mainKey.currentState.showSnackBar(new SnackBar(
                              content: Text(
                                  "Organization User Profile Updation Failed"),
                              duration: Duration(milliseconds: 1000)));
                        } else {}
                        // Run the code here using the value
                      });
                    }
                  },
                )
              ],
            ), //Text('Hello $name'),
            decoration: BoxDecoration(
              color: Colors.orange[100],
            ),
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyStatefulWidget()));
            },
          ),
          ListTile(
            title: Text('Contact'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyStatefulWidget()));
            },
          ),
          ListTile(
            title: Text('Support'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyStatefulWidget()));
            },
          ),
          ListTile(
            title: Text('Share'),
            onTap: () {
              // Update the state of the appR
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyStatefulWidget()));
            },
          ),
          ListTile(
            title: Text('Enquiry'),
            onTap: () async {
              // Update the state of the app
              // ...
              // Then close the drawer
              // final storage = new FlutterSecureStorage();
              // await storage.deleteAll();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UserLogin()));
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              // Update the state of the app
              // ...
              // Then close the drawer
              // final storage = new FlutterSecureStorage();
              // await storage.deleteAll();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UserLogin()));
            },
          ),
        ],
      ),
    );
  }
}
