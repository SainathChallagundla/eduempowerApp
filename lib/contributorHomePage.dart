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
import 'package:eduempower/funds/addfundRequest.dart';
import 'package:eduempower/funds/viewFundRequests.dart';

class ContributorHomePage extends StatefulWidget {
  final String title;
  @override
  ContributorHomePageState createState() => ContributorHomePageState();
  ContributorHomePage({Key key, this.title}) : super(key: key);
}

enum popupmenu { harder, smarter, selfStarter, tradingCharter }

class ContributorHomePageState extends State<ContributorHomePage> {
  String token, email, name, userType, userCategory, _mySelection;
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
        .getBeneficiaries(url, token, 0, 0, "all");
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
      // body: buildcardListView(data),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          // dropdown for status
          new DropdownButton<String>(
            items: <String>[
              'all',
              'created',
              'approved',
              'rejected',
              'archived'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Text("Select a status"),
            onChanged: (newVal) async {
              setState(() {
                _mySelection = newVal;
              });
              var list = await beneficiarieDetails_helper.BeneficiarieDetails()
                  .getBeneficiaries(url, token, 0, 0, _mySelection);
              setState(() {
                data = list;
              });
            },
            value: _mySelection,
          ),
          Expanded(child: buildcardListView(data))
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.group_add_outlined),
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

  ListView buildcardListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.orange[300], width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "name:${data != null ? data[index].name : ""}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(data != null ? data[index].statusForFunding : ""),
                      Text(data != null ? data[index].lastUpdated : ""),
                    ],
                  ),
                  _offsetPopup(index)
                ],
              ));
        },
      );
    } else {
      return ListView();
    }
  }

  Widget _offsetPopup(index) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: data[index].user == email
                  ? Container()
                  : FlatButton.icon(
                      icon: Icon(Icons.edit_outlined),
                      label: Text("Edit Beneficiarie"),
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
                    )),
          PopupMenuItem(
              value: 2,
              child: FlatButton.icon(
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
                  icon: Icon(Icons.view_list_outlined),
                  label: Text("View Beneficiatie Details"))),
          PopupMenuItem(
            value: 3,
            child: FlatButton.icon(
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
          ),
          data[index].statusForFunding == "approved" ||
                  data[index].statusForFunding == "created"
              ? PopupMenuItem(
                  value: 4,
                  child: FlatButton.icon(
                      onPressed: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FundRequestPage(
                                  id: data != null ? data[index].id : "")),
                        );
                        setState(() {
                          this.reload = result ?? false;
                        });
                        if (result ?? false) {
                          this.getInit();
                        }
                      },
                      icon: Icon(Icons.request_page_rounded),
                      label: Text("Request For Fund")))
              : PopupMenuItem(child: Container()),
          PopupMenuItem(
              child: FlatButton.icon(
                  onPressed: () async {
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewFundRequestsPage(
                              id: data != null ? data[index].id : "")),
                    );
                    setState(() {
                      this.reload = result ?? false;
                    });
                    if (result ?? false) {
                      this.getInit();
                    }
                  },
                  icon: Icon(Icons.money_rounded),
                  label: Text("Fund Requestes")))
        ],
        icon: Icon(Icons.format_list_bulleted),
      );
}
