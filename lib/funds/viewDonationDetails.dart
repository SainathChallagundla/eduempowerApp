import 'package:eduempower/models/donations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ViewDonationsPage extends StatefulWidget {
  final String id;
  @override
  _ViewDonationsPageeState createState() => _ViewDonationsPageeState();
  ViewDonationsPage({Key key, this.id}) : super(key: key);
}

class _ViewDonationsPageeState extends State<ViewDonationsPage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  Donation fundData = Donation();

  //List<funds_model.Fund> data = List<funds_model.Fund>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONBYID;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(widget.id);
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var details = await HttpHelper().getDonationById(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONBYID,
        widget.id,
        token);
    setState(() {
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
                  initialValue: fundData.proposedAmount.toString(),
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
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}
