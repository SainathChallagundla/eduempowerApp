import 'package:eduempower/beneficiaries/beneficiarie.dart';
import 'package:eduempower/beneficiaries/documents.dart';
import 'package:eduempower/beneficiaries/editBeneficiarie.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;

class ContributorHomePage extends StatefulWidget {
  final String title;
  @override
  ContributorHomePageState createState() => ContributorHomePageState();
  ContributorHomePage({Key key, this.title}) : super(key: key);
}

class ContributorHomePageState extends State<ContributorHomePage> {
  String token, email, name, userType, userCategory, _mySelection;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<beneficiarieDetails_model.BeneficiarieDetails> data = []; //edited line

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
    );
  }

  ListView buildcardListView(
      List<beneficiarieDetails_model.BeneficiarieDetails> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: _itemBuilder,
        // itemBuilder: (context, index) {
        //   return Card(
        //       margin: EdgeInsets.all(10),
        //       shape: RoundedRectangleBorder(
        //         side: new BorderSide(color: Colors.orange[300], width: 1.0),
        //         borderRadius: BorderRadius.circular(15.0),
        //       ),
        //       child: Container(
        //           padding: EdgeInsets.all(10),
        //           child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: <Widget>[
        //                 Row(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: <Widget>[
        //                     Text("Name :"),
        //                     Text(data != null ? data[index].name : ""),
        //                   ],
        //                 ),
        //                 Row(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: <Widget>[
        //                       Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         mainAxisAlignment:
        //                             MainAxisAlignment.spaceBetween,
        //                         children: <Widget>[
        //                           TextButton.icon(
        //                               // color: Colors.orange[300],
        //                               onPressed: () async {
        //                                 bool result = await Navigator.push(
        //                                   context,
        //                                   MaterialPageRoute(
        //                                       builder: (context) =>
        //                                           ViewBeneficiariePage(
        //                                               id: data != null
        //                                                   ? data[index].id
        //                                                   : "")),
        //                                 );
        //                                 setState(() {
        //                                   this.reload = result;
        //                                 });
        //                                 if (result == true) {
        //                                   this.getInit();
        //                                 }
        //                               },
        //                               icon: Icon(Icons.view_list_outlined),
        //                               label: Text("View Details")),
        //                           data[index].user == email
        //                               ? Container()
        //                               : TextButton.icon(
        //                                   icon: Icon(Icons.edit_outlined),
        //                                   label: Text(
        //                                     "Edit Details",
        //                                     //style: TextStyle(color: Colors.black),
        //                                   ),
        //                                   onPressed: () async {
        //                                     bool result =
        //                                         await Navigator.push(
        //                                       context,
        //                                       MaterialPageRoute(
        //                                           builder: (context) =>
        //                                               EditBeneficiariePage(
        //                                                   id: data != null
        //                                                       ? data[index].id
        //                                                       : "")),
        //                                     );
        //                                     setState(() {
        //                                       this.reload = result ?? false;
        //                                     });
        //                                     if (result ?? false) {
        //                                       this.getInit();
        //                                     }
        //                                   },
        //                                 ),
        //                           TextButton.icon(
        //                             icon: Icon(Icons.file_present),
        //                             label: Text("Documents"),
        //                             onPressed: () async {
        //                               bool result = await Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (context) =>
        //                                         DocumentsPage(
        //                                             id: data != null
        //                                                 ? data[index].id
        //                                                 : "")),
        //                               );
        //                               setState(() {
        //                                 this.reload = result;
        //                               });
        //                               if (result == true) {
        //                                 this.getInit();
        //                               }
        //                             },
        //                           ),
        //                         ],
        //                       ),
        //                       Column(
        //                           crossAxisAlignment:
        //                               CrossAxisAlignment.start,
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: <Widget>[
        //                             data[index].statusForFunding == "approved"
        //                                 //||data[index].statusForFunding == "created"
        //                                 ? TextButton.icon(
        //                                     onPressed: () async {
        //                                       bool result =
        //                                           await Navigator.push(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 FundRequestPage(
        //                                                     id: data != null
        //                                                         ? data[index]
        //                                                             .id
        //                                                         : "")),
        //                                       );
        //                                       setState(() {
        //                                         this.reload = result ?? false;
        //                                       });
        //                                       if (result ?? false) {
        //                                         this.getInit();
        //                                       }
        //                                     },
        //                                     icon: Icon(
        //                                         Icons.request_page_rounded),
        //                                     label: Text("Request For Fund"))
        //                                 : Container(),
        //                             TextButton.icon(
        //                                 onPressed: () async {
        //                                   bool result = await Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             ViewFundRequestsPage(
        //                                                 id: data != null
        //                                                     ? data[index].id
        //                                                     : "")),
        //                                   );
        //                                   setState(() {
        //                                     this.reload = result ?? false;
        //                                   });
        //                                   if (result ?? false) {
        //                                     this.getInit();
        //                                   }
        //                                 },
        //                                 icon: Icon(Icons.money_rounded),
        //                                 label: Text("Fund Requestes"))
        //                           ])
        //                     ])
        //               ])));
        // }
      );
    } else {
      return ListView();
    }
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      // height: 100,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: _getWidgetListAll(data[index]),
        ),
      ),
    );
  }

  List<Widget> _getWidgetListAll(
      beneficiarieDetails_model.BeneficiarieDetails details) {
    List<Widget> listWidgets = [];

    var nameWidget = _getTextField(details.name, "Name", "");

    var fundingStatusWidget =
        _getTextField(details.statusForFunding, "Funding Status", "");
    var statusWidget = _getTextField(details.status, "Status", "");

    listWidgets.add(nameWidget);

    listWidgets.addAll(_getWidgetList(details.data));
    listWidgets.add(fundingStatusWidget);
    listWidgets.add(statusWidget);
    listWidgets.add(details.user == email
        ? Container(
            height: 0,
            width: 0,
          )
        : Container(
            width: 150.0,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: OutlinedButton(
              child: Text("Edit Details"),
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBeneficiariePage(
                          id: data != null ? details.id : "")),
                );
                setState(() {
                  this.reload = result ?? false;
                });
                if (result ?? false) {
                  this.getInit();
                }
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red)))),
            )));
    listWidgets.add(Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: OutlinedButton(
          child: Text("Documents"),
          onPressed: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DocumentsPage(id: details != null ? details.id : "")),
            );
            setState(() {
              this.reload = result;
            });
            if (result == true) {
              this.getInit();
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red)))),
        )));
    listWidgets.add(Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: OutlinedButton(
          child: Text("Request for fund"),
          onPressed: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FundRequestPage(id: details != null ? details.id : "")),
            );
            setState(() {
              this.reload = result ?? false;
            });
            if (result ?? false) {
              this.getInit();
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red)))),
        )));
    listWidgets.add(Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: OutlinedButton(
          child: Text("Fund Requests"),
          onPressed: () async {
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewFundRequestsPage(
                      id: details != null ? details.id : "")),
            );
            setState(() {
              this.reload = result ?? false;
            });
            if (result ?? false) {
              this.getInit();
            }
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red)))),
        )));

    return listWidgets;
  }

  List<Widget> _getWidgetList(
      List<beneficiarieDetails_model.TemplateDataFields> data) {
    List<Widget> listWidgets = [];
    data.forEach((element) {
      listWidgets
          .add(_getTextField(element.value, element.header, element.name));
    });
    return listWidgets;
  }

  Widget _getTextField(String value, String heading, String name) {
    return Container(
        width: 150.0,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          maxLines: 3,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: new BorderSide(color: Colors.orange, width: 1.0)),
            labelText: heading,
          ),
        ));
  }
}
