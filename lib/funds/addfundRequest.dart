import 'package:eduempower/funds/viewFundRequests.dart';
import 'package:eduempower/models/fundRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';

class FundRequestPage extends StatefulWidget {
  final String id;
  FundRequestPage({Key key, this.id}) : super(key: key);

  @override
  _FundRequestPageState createState() => _FundRequestPageState();
}

class _FundRequestPageState extends State<FundRequestPage> {
  String beneficiarieID, moreInfo, status, lastUpdated, token;
  num fundRequired;
  final mainKey = GlobalKey<ScaffoldState>();
  DateTime fundRequiredBy = DateTime.now();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
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
      resizeToAvoidBottomInset: false,
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
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          hintText: 'Enter Request Amount'),
                      onChanged: (text) {
                        fundRequired = double.parse(text);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                        maxLines: 3,
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            hintText: 'More Info'),
                        onChanged: (text) {
                          moreInfo = text;
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.orange[300],
                      onPressed: () => _selectDate(context),
                      child: Text('Select date FundRequiredBy'),
                    ),
                    Text(
                      "AmountRequiredBy:${fundRequiredBy.toLocal()}"
                          .split(' ')[0],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            await onSubmit(context);
          }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != fundRequiredBy)
      setState(() {
        fundRequiredBy = picked;
      });
  }

  Future<void> onSubmit(BuildContext context) async {
    FundRequest fundRequest = new FundRequest(
      fundRequired: fundRequired,
      fundRequiredBy: fundRequiredBy.toString(),
      moreInfo: moreInfo,
      status: "active",
    );

    var result = await fundDetails_helper.FundDetails().addFundRequest(
        HttpEndPoints.BASE_URL +
            HttpEndPoints.ADD_FUNDREQUEST +
            "/" +
            widget.id,
        token,
        fundRequest);
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
