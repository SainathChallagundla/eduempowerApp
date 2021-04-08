import 'package:eduempower/public/login.dart';
import 'package:eduempower/beneficiaries/beneficiarie.dart';
import 'package:eduempower/beneficiaries/documents.dart';
import 'package:eduempower/beneficiaries/editBeneficiarie.dart';
import 'package:eduempower/beneficiaries/viewBeneficiarie.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/dropdown.dart';
import 'package:flutter/cupertino.dart';

import 'package:eduempower/drawer/individual.dart';
import 'package:eduempower/drawer/organization.dart';

import 'package:eduempower/helpers/httphelper.dart';

import 'package:eduempower/models/beneficiarieDetails.dart'
    as beneficiarieDetails_model;
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/funds/donarfunds.dart';

class HomePage extends StatefulWidget {
  final String title;
  @override
  createState() => HomePageState();
  HomePage({Key key, this.title}) : super(key: key);
}

class HomePageState extends State<HomePage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<beneficiarieDetails_model.BeneficiarieDetails> data =
      List<beneficiarieDetails_model.BeneficiarieDetails>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIES;

  // final storage = new FlutterSecureStorage();
  void getInit() async {
    //   token = await storage.read(key: "token");
    //   email = await storage.read(key: "email");
    //   name = await storage.read(key: "name");
    //   userType = await storage.read(key: "userType");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var list = await beneficiarieDetails_helper.BeneficiarieDetails()
        .getBeneficiaries(url, token, 0, 0, "created");

    setState(() {
      data = list;
    });
    //var list =  await HttpHelper().getBeneficiaries(url, token, 0, 0);
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
        key: mainKey,
        appBar: AppBar(
            title: Text(widget.title,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Logofont',
                    fontWeight: FontWeight.bold,
                    fontSize: 20))),
        body: buildListView(data),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: userCategory == "donar"
              //? const Icon(Icons.money)
              ? const Text(
                  "\u{20B9}",
                  style: TextStyle(fontSize: 40),
                )
              : const Icon(Icons.person_add),
          onPressed: () async {
            if (userCategory == "donar") {
              bool result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonarFundsPage()),
              );
            } else {
              bool result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BeneficiariePage()),
              );
              setState(() {
                this.reload = result;
              });
              if (result == true) {
                this.getInit();
              }
            }
          },
        ),
        bottomNavigationBar: _bottonNavBar(context),
        drawer: _drawer(context));
  }

  Widget _bottonNavBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            // iconSize: 50,
            icon: Image.asset(
              'assets/images/Beneficiaries.png',
            ),
            onPressed: () {},
          ),
          /* GestureDetector(
            onTap: () {
              print("Muruga........");
            },
            child: Tab(
              icon: Container(
                child: Image(
                  image: AssetImage(
                    'assets/images/Beneficiaries.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),*/
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
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

  ListView buildListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
              // title: Text(data != null ? data[index].name : ""),
              title: Text(data[index].name ?? ""),
              leading: IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () async {
                  bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditBeneficiariePage(
                            id: data != null ? data[index].id : "")),
                  );
                  setState(() {
                    this.reload = result ?? false;
                  });
                  if (result ?? false) {
                    this.getInit();
                  }
                },
              ),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.file_present),
                  onPressed: () async {
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentsPage(
                              id: data != null ? data[index].id : "")),
                    );
                    setState(() {
                      this.reload = result;
                    });
                    if (result == true) {
                      this.getInit();
                    }
                  },
                ),
                IconButton(
                    onPressed: () async {
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBeneficiariePage(
                                id: data != null ? data[index].id : "")),
                      );
                      setState(() {
                        this.reload = result;
                      });
                      if (result == true) {
                        this.getInit();
                      }
                    },
                    icon: Icon(Icons.view_list_outlined))
              ]));
        },
      );
    } else {
      return ListView();
    }
  }
}
