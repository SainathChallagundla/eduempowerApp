import 'package:eduempower/models/funds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class DonarFundsPage extends StatefulWidget {
  DonarFundsPage({Key key}) : super(key: key);

  @override
  _DonarFundsPageState createState() => _DonarFundsPageState();
}

class _DonarFundsPageState extends State<DonarFundsPage> {
  String referenceNo, moreInfo, token, email, paymentMode;
  double proposedAmount;
  List data = List(); //edited line
  BeneficiarieTemplate templateData;
  bool isLoaded = false;
  final mainKey = GlobalKey<ScaffoldState>();
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
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
          title: Text("Add Funds",
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Enter Proposed Amount'),
                    onChanged: (text) {
                      print("Enter Proposed Amount-------------$text");
                      proposedAmount = double.parse(text);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Mode Of Payment'),
                    onChanged: (text) {
                      paymentMode = text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Referance No.'),
                    onChanged: (text) {
                      referenceNo = text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: 3,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'More Info'),
                    onChanged: (text) {
                      moreInfo = text;
                    },
                  ),
                  SizedBox(height: 20),
                  IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(type: FileType.any);
                        String filePath;
                        if (result != null) {
                          filePath = result.files.single.path;
                        }
                      },
                      icon: Column(children: <Widget>[
                        Icon(
                          Icons.attach_file,
                          color: Colors.orange[200],
                        ),
                      ])),
                  Text(
                    "Attach Document/Image",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            await onSubmit(context);
          }),
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    Fund fundsPage = new Fund(
        amountProposed: proposedAmount,
        modeOfPayment: paymentMode,
        referenceNo: referenceNo,
        moreInfo: moreInfo,
        donorEmail: email);

    print(proposedAmount);
    var result = await beneficiarieDetails_helper.BeneficiarieDetails().addFund(
        HttpEndPoints.BASE_URL + HttpEndPoints.ADD_FUND, token, fundsPage);
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
