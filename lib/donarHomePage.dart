import 'package:eduempower/beneficiaries/documents.dart';
import 'package:eduempower/beneficiaries/viewBeneficiarie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieDetails.dart'
    as beneficiarieDetails_model;
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/funds/viewFundRequests.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DonarHomePage extends StatefulWidget {
  final String title, id;
  @override
  DonarHomePageState createState() => DonarHomePageState();
  DonarHomePage({Key key, this.title, this.id}) : super(key: key);
}

class DonarHomePageState extends State<DonarHomePage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();
  List<beneficiarieDetails_model.BeneficiarieDetails> data = [];
//edited line
  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIES;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var list = await beneficiarieDetails_helper.BeneficiarieDetails()
        .getBeneficiaries(url, token, 0, 0, "approved");

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
        body: _WebView(data)
        // : buildcardListView(data),
        );
  }

  Widget buildcardListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.orange[300], width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Name :"),
                          Text(data != null ? data[index].name : ""),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextButton.icon(
                                    // color: Colors.orange[300],
                                    onPressed: () async {
                                      bool result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewBeneficiariePage(
                                                    id: data != null
                                                        ? data[index].id
                                                        : "")),
                                      );
                                      setState(() {
                                        this.reload = result;
                                      });
                                      if (result == true) {
                                        this.getInit();
                                      }
                                    },
                                    icon: Icon(Icons.view_list_outlined),
                                    label: Text("View Details")),
                                TextButton.icon(
                                  icon: Icon(Icons.file_present),
                                  label: Text("Documents"),
                                  onPressed: () async {
                                    bool result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DocumentsPage(
                                              id: data != null
                                                  ? data[index].id
                                                  : "")),
                                    );
                                    setState(() {
                                      this.reload = result;
                                    });
                                    if (result == true) {
                                      this.getInit();
                                    }
                                  },
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextButton.icon(
                                    onPressed: () async {
                                      bool result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewFundRequestsPage(
                                                    id: data != null
                                                        ? data[index].id
                                                        : "")),
                                      );
                                      setState(() {
                                        this.reload = result ?? false;
                                      });
                                      if (result ?? false) {
                                        this.getInit();
                                      }
                                    },
                                    icon: Icon(Icons.money_rounded),
                                    label: Text("Fund Requests")),
                              ],
                            )
                          ])
                    ],
                  )));
        },
      );
    } else {
      return ListView(
        children: <Widget>[Text("No Fund Request added")],
      );
    }
  }

  Widget _WebView(List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            data?.length ?? 0,
            (index) {
              return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.orange[300], width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Name :"),
                            Text(data != null ? data[index].name : ""),
                          ],
                        ),
                        TextButton.icon(
                            // color: Colors.orange[300],
                            onPressed: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewBeneficiariePage(
                                        id: data != null
                                            ? data[index].id
                                            : "")),
                              );
                              setState(() {
                                this.reload = result;
                              });
                              if (result == true) {
                                this.getInit();
                              }
                            },
                            icon: Icon(Icons.view_list_outlined),
                            label: Text("View Details")),
                        TextButton.icon(
                          icon: Icon(Icons.file_present),
                          label: Text("Documents"),
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
                        TextButton.icon(
                            onPressed: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewFundRequestsPage(
                                        id: data != null
                                            ? data[index].id
                                            : "")),
                              );
                              setState(() {
                                this.reload = result ?? false;
                              });
                              if (result ?? false) {
                                this.getInit();
                              }
                            },
                            icon: Icon(Icons.money_rounded),
                            label: Text("Fund Requests")),
                      ],
                    ),
                  ));
            },
          ));
    } else {
      return ListView(
        children: <Widget>[Text("No Fund Request added")],
      );
    }
  }
}
