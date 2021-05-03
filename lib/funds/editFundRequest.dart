import 'package:eduempower/funds/viewFundRequests.dart';
import 'package:eduempower/models/fundRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';

class EditFundRequestPage extends StatefulWidget {
  num requiredFund;
  String moreInfo, id;
  EditFundRequestPage({Key key, this.moreInfo, this.requiredFund, this.id})
      : super(key: key);

  @override
  _EditFundRequestPageState createState() => _EditFundRequestPageState();
}

class _EditFundRequestPageState extends State<EditFundRequestPage> {
  String beneficiarieID, moreInfo, status, lastUpdated, token;
  num fundRequired;
  final mainKey = GlobalKey<ScaffoldState>();
  FundRequest fundRequestData = FundRequest();
  int index;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(widget.id);
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
          title: Text("Edit FundRequest",
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
                      initialValue: widget.requiredFund.toString(),
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
                        fundRequired = num.parse(text);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                        initialValue: widget.moreInfo,
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
                        })
                  ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            var fundRequest = Map<String, dynamic>();
            fundRequest["fundRequired"] = fundRequired;
            fundRequest["moreInfo"] = moreInfo;
            await onSubmit(context, fundRequest);
          }),
    );
  }

  Future<void> onSubmit(
      BuildContext context, Map<String, dynamic> fundRequest) async {
    fundRequest["fundRequired"] = fundRequired;
    fundRequest["moreInfo"] = moreInfo;

    var result = await fundDetails_helper.FundDetails().updatefundRequestById(
        HttpEndPoints.BASE_URL +
            HttpEndPoints.UPDATE_FUNDREQUESTBYID +
            widget.id,
        token,
        fundRequest);
    print(widget.id);
    if (result.status == "success") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewFundRequestsPage(id: widget.id)),
      );
    } else {
      Navigator.pop(context, false);
    }
  }
}
