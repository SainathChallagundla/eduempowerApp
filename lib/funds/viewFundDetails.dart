import 'package:eduempower/models/funds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewFundDetailsPage extends StatefulWidget {
  final String id;
  @override
  ViewFundDetailsPageState createState() => ViewFundDetailsPageState();
  ViewFundDetailsPage({Key key, this.id}) : super(key: key);
}

class ViewFundDetailsPageState extends State<ViewFundDetailsPage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  Fund fundData = Fund();

  //List<funds_model.Fund> data = List<funds_model.Fund>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDSBYID;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(widget.id);
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var details = await HttpHelper().getFundById(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDSBYID, widget.id, token);
    setState(() {
      print(details);
      fundData = details;
      isLoaded = true;
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
          title: Text("",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: gridView(context),
    );
  }

  Widget gridView(BuildContext context) {
    if (isLoaded) {
      return new Container(
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  initialValue: fundData.amountProposed.toString(),
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      hintText: 'Enter Proposed Amount'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: fundData.modeOfPayment,
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      hintText: 'Mode Of Payment'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: fundData.referenceNo,
                  decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      hintText: 'Referance No.'),
                ),
                SizedBox(height: 20),
                TextFormField(
                    initialValue: fundData.moreInfo,
                    maxLines: 3,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0)),
                        hintText: 'More Info'))
              ]));
    } else {
      print("..............");
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}
