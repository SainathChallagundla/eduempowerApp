import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:eduempower/models/beneficiarieDataFields.dart'
    as beneficiarieDataFields_model;
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditBeneficiariePage extends StatefulWidget {
  final String id;
  @override
  createState() => _EditBeneficiariePageState();
  EditBeneficiariePage({Key key, this.id}) : super(key: key);
}

class _EditBeneficiariePageState extends State<EditBeneficiariePage> {
  String token, email, name;
  bool isLoaded = false;

  BeneficiarieDetails benediciarieData = BeneficiarieDetails();

  beneficiarieDataFields_model.BeneficiarieDataFields dataFields =
      beneficiarieDataFields_model.BeneficiarieDataFields();

  //final storage = new FlutterSecureStorage();
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");

    // token = await storage.read(key: "token");
    // email = await storage.read(key: "email");

    var details = await HttpHelper().getBeneficiarieById(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIEBYID,
        widget.id,
        token);

    setState(() {
      benediciarieData = details;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text("Edit Beneficiarie",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: Center(
          child: Container(
              margin: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextField(
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          labelText: benediciarieData.name),
                      readOnly: true,
                      onChanged: (text) {
                        name = text;
                      },
                    ),

                    SizedBox(height: 20),
                    new Expanded(child: gridView(context, benediciarieData)),
                    SizedBox(height: 20),
                    // To do here ..
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Update"),
                          onPressed: () {
                            onSubmit(context);
                          },
                        ),
                        RaisedButton(
                          color: Colors.orange,
                          child: Text("Approve"),
                          onPressed: onApprove(benediciarieData) == null
                              ? null
                              : () {
                                  var fields = new Map<String, dynamic>();
                                  fields["statusForFunding"] = "approved";
                                  onSubSubmit(context, fields);
                                },
                          //onPressed: onApprove(benediciarieData),
                        ),
                        RaisedButton(
                          onPressed: () {
                            var fields = new Map<String, dynamic>();
                            fields["statusForFunding"] = "rejected";
                            onSubSubmit(context, fields);
                          },
                          color: Colors.orange,
                          child: Text("Reject"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            var fields = new Map<String, dynamic>();
                            fields["statusForFunding"] = "archived";
                            onSubSubmit(context, fields);
                          },
                          color: Colors.orange,
                          child: Text("Archive"),
                          // ),
                        ),
                      ],
                    ),
                  ]))),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //floatingActionButton: FloatingActionButton(
      //  child: const Icon(Icons.update),
      //onPressed: () {
      //onSubmit(context);
      //}),
    );
  }

  Widget rowVerify(BuildContext context, bool tobeVerified, int index,
      BeneficiarieDetails beneficiarieDetails) {
    if (tobeVerified) {
      /*print(getVerificationText(
              beneficiarieDetails?.data[index]?.verification?.status ?? "") ??
          "Approve");*/
      return Expanded(
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            FlatButton(
              child: Text(
                getVerificationText(beneficiarieDetails
                            ?.data[index]?.verification?.status ??
                        "") ??
                    "Approve",
                style: new TextStyle(
                  color: getVerificationText(beneficiarieDetails
                                  ?.data[index]?.verification?.status ??
                              "") ==
                          "Approved"
                      ? Colors.green
                      : Colors.blue,
                ),
              ),
              onPressed: () {
                if (beneficiarieDetails != null &&
                    beneficiarieDetails.data.isNotEmpty) {
                  var item = beneficiarieDetails.data[index];
                  item.verification.status = "approved";
                  item.verification.verifiedBy = email;
                  beneficiarieDetails.data.removeAt(index);
                  beneficiarieDetails.data.insert(index, item);
                }
              },
            ),
            FlatButton(
              child: Text(
                "Reject",
                style: new TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                if (beneficiarieDetails != null &&
                    beneficiarieDetails.data.isNotEmpty) {
                  var item = beneficiarieDetails.data[index];
                  item.verification.status = "rejected";
                  item.verification.verifiedBy = email;
                  beneficiarieDetails.data.removeAt(index);
                  beneficiarieDetails.data.insert(index, item);
                }
              },
            )
          ]));
    }
    return Container(height: 0);
  }

  Widget gridView(
      BuildContext context, BeneficiarieDetails beneficiarieDetails) {
    if (isLoaded ?? false) {
      return new GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: beneficiarieDetails?.data?.length ?? 0,
          shrinkWrap: true,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: kIsWeb ? 10.0 : 3.0),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Container(
                alignment: Alignment.topLeft,
                margin: new EdgeInsets.all(1.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Expanded(
                        child:
                            Text(beneficiarieDetails.data[index].header + ":")),
                    TextField(
                      key: Key("${beneficiarieDetails.data[index]..name}"),
                      keyboardType: TextInputType.multiline,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp(beneficiarieDetails.data[index].regex))
                      ],
                      maxLines: 2,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        labelText: beneficiarieDetails.data[index].value,
                      ),
                      onChanged: (text) {
                        if (beneficiarieDetails != null &&
                            beneficiarieDetails.data.isNotEmpty) {
                          var item = beneficiarieDetails.data.where((m) {
                            return m.name ==
                                beneficiarieDetails.data[index].name;
                          }).single;
                          item.value = text;
                          beneficiarieDetails.data.removeAt(index);
                          beneficiarieDetails.data.insert(index, item);
                          // beneficiarieDetails.data.replaceRange(index, index, [item]);
                        }
                      },
                    ),
                    rowVerify(
                        context,
                        beneficiarieDetails
                            .data[index].verification.toBeVerified,
                        index,
                        beneficiarieDetails),
                  ],
                ), //new Text('Item $index'),
              ),
            );
          });
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  void onSubmit(BuildContext context) async {
    benediciarieData.data.forEach((item) {
      if (dataFields != null && dataFields.data == null) {
        dataFields.data = List<TemplateDataFields>();
      }
      dataFields.data.add(item);
    });
    var result = await beneficiarieDetails_helper.BeneficiarieDetails()
        .updateBenificiarieFileds(
            HttpEndPoints.BASE_URL +
                HttpEndPoints.UPDATE_BENEFICIARIE_FIELDS +
                widget.id,
            token,
            dataFields);

    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }

  void onSubSubmit(BuildContext context, Map<String, dynamic> fields) async {
    var result = await beneficiarieDetails_helper.BeneficiarieDetails()
        .updateBenificiarieDetailsById(
            HttpEndPoints.BASE_URL +
                HttpEndPoints.UPDATE_BENEFICIARIE_DETAILS_ID +
                widget.id,
            token,
            fields);

    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }

  String getVerificationText(String text) {
    //print(text);
    if (text == "approved") {
      return "Approved";
    }
    return "Approve";
  }

  Function onApprove(BeneficiarieDetails beneficiarieDetails) {
    bool result = false;

    Iterator i = beneficiarieDetails?.data?.iterator;

    while (i?.moveNext() ?? false) {
      var item = i.current as TemplateDataFields;

      if ((item.verification.toBeVerified == true) &&
          (item.verification.status != "approved")) {
        result = true;
        break;
      }
    }
    if (result) {
      return null;
    } else {
      return () {
        onSubmit(context);
      };
    }
  }
}
