import 'package:eduempower/beneficiaries/beneficiarie.dart';
import 'package:eduempower/beneficiaries/documents.dart';
import 'package:eduempower/beneficiaries/editBeneficiarie.dart';
import 'package:eduempower/beneficiaries/viewBeneficiarie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieDetails.dart'
    as beneficiarieDetails_model;
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/funds/addfunds.dart';
import 'package:eduempower/funds/viewfunds.dart';

class ContributorHomePage extends StatefulWidget {
  final String title;
  @override
  ContributorHomePageState createState() => ContributorHomePageState();
  ContributorHomePage({Key key, this.title}) : super(key: key);
}

class ContributorHomePageState extends State<ContributorHomePage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<beneficiarieDetails_model.BeneficiarieDetails> data =
      List<beneficiarieDetails_model.BeneficiarieDetails>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIES;

  void getInit() async {
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
          centerTitle: true,
          title: Text("Beneficiaries",
              //widget.title,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: buildcardListView(data),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.person_add),
          onPressed: () async {
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
          }),
      // bottomNavigationBar: _bottonNavBar(context, 0),
      // drawer: _drawer(context)
    );
  }

  // Widget _bottonNavBar(BuildContext context, int index) {
  //   return BottomAppBar(
  //     shape: CircularNotchedRectangle(),
  //     notchMargin: 4.0,
  //     child: new Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         IconButton(
  //           iconSize: 50,
  //           icon: Image.asset(
  //             'assets/images/Beneficiaries.png',
  //           ),
  //           onPressed: () {},
  //         ),
  //         /* GestureDetector(
  //           onTap: () {
  //             print("Muruga........");
  //           },
  //           child: Tab(
  //             icon: Container(
  //               child: Image(
  //                 image: AssetImage(
  //                   'assets/images/Beneficiaries.png',
  //                 ),
  //                 fit: BoxFit.contain,
  //               ),
  //             ),
  //           ),
  //         ),*/
  //         IconButton(
  //           icon: Icon(Icons.menu),
  //           onPressed: () async {
  //             bool result = await Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => ViewFundsPage()),
  //             );
  //             setState(() {
  //               this.reload = result;
  //             });
  //             if (result == true) {
  //               this.getInit();
  //             }
  //             icon:
  //             Icon(Icons.view_list_outlined);
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.search),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _drawer(BuildContext context) {
  //   return Drawer(
  //     // Add a ListView to the drawer. This ensures the user can scroll
  //     // through the options in the drawer if there isn't enough vertical
  //     // space to fit everything.
  //     child: ListView(
  //       // Important: Remove any padding from the ListView.
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         DrawerHeader(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             verticalDirection: VerticalDirection.down,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Expanded(
  //                   child: Center(
  //                       child: Text("Edu Empower",
  //                           style: TextStyle(
  //                               color: Colors.grey,
  //                               fontFamily: 'Logofont',
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 20)))),
  //               SizedBox(height: 5),
  //               Text('Hello $name'),
  //               SizedBox(height: 5),
  //               Text('Registered Email: $email'),
  //               SizedBox(height: 5),
  //               OutlineButton(
  //                 child: Text("Edit Profile"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   if (userType == "individual") {
  //                     Navigator.of(context)
  //                         .push(MaterialPageRoute(
  //                             builder: (BuildContext context) =>
  //                                 IndividualPage()))
  //                         .then((value) {
  //                       if (value == true) {
  //                         mainKey.currentState.showSnackBar(new SnackBar(
  //                             content: Text("User Profile Updation Successful"),
  //                             duration: Duration(milliseconds: 1000)));
  //                       } else if (value == false) {
  //                         mainKey.currentState.showSnackBar(new SnackBar(
  //                             content: Text("User Profile Updation Failed"),
  //                             duration: Duration(milliseconds: 1000)));
  //                       } else {}
  //                       // Run the code here using the value
  //                     });
  //                   } else if (userType == "organization") {
  //                     Navigator.of(context)
  //                         .push(MaterialPageRoute(
  //                             builder: (BuildContext context) =>
  //                                 OrganizationPage()))
  //                         .then((value) {
  //                       if (value == true) {
  //                         mainKey.currentState.showSnackBar(new SnackBar(
  //                             content: Text(
  //                                 "Organization User Profile Updation Successful"),
  //                             duration: Duration(milliseconds: 1000)));
  //                       } else if (value == false) {
  //                         mainKey.currentState.showSnackBar(new SnackBar(
  //                             content: Text(
  //                                 "Organization User Profile Updation Failed"),
  //                             duration: Duration(milliseconds: 1000)));
  //                       } else {}
  //                       // Run the code here using the value
  //                     });
  //                   }
  //                 },
  //               )
  //             ],
  //           ), //Text('Hello $name'),
  //           decoration: BoxDecoration(
  //             color: Colors.orange[100],
  //           ),
  //         ),
  //         ListTile(
  //           title: Text('About'),
  //           onTap: () {
  //             // Update the state of the app
  //             // ...
  //             // Then close the drawer
  //             Navigator.pop(context);
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => MyStatefulWidget()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Contact'),
  //           onTap: () {
  //             // Update the state of the app
  //             // ...
  //             // Then close the drawer
  //             Navigator.pop(context);
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => MyStatefulWidget()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Support'),
  //           onTap: () {
  //             // Update the state of the app
  //             // ...
  //             // Then close the drawer
  //             Navigator.pop(context);
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => MyStatefulWidget()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Share'),
  //           onTap: () {
  //             // Update the state of the appR
  //             // ...
  //             // Then close the drawer
  //             Navigator.pop(context);
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => MyStatefulWidget()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Enquiry'),
  //           onTap: () async {
  //             // Update the state of the app
  //             // ...
  //             // Then close the drawer
  //             // final storage = new FlutterSecureStorage();
  //             // await storage.deleteAll();
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             await prefs.clear();
  //             Navigator.of(context).pop();
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => UserLogin()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Logout'),
  //           onTap: () async {
  //             // Update the state of the app
  //             // ...
  //             // Then close the drawer
  //             // final storage = new FlutterSecureStorage();
  //             // await storage.deleteAll();
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             await prefs.clear();
  //             Navigator.of(context).pop();
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (BuildContext context) => UserLogin()));
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  ListView buildListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
              // title: Text(data != null ? data[index].name : ""),
              title: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.orange[300],
                  child: Column(children: [
                    Text(data != null ? data[index].name : ""),
                    Text(data != null ? data[index].statusForFunding : ""),
                    Text(data != null ? data[index].lastUpdated : ""),
                  ])), //Text(data[index].name ?? ""),
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

  ListView buildcardListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("name:${data != null ? data[index].name : ""}"),
                  Text(data != null ? data[index].statusForFunding : ""),
                  Text(data != null ? data[index].lastUpdated : ""),
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
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
                ],
              )
            ],
          ));
        },
      );
    } else {
      return ListView();
    }
  }
}
