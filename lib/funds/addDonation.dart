import 'package:eduempower/models/donations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class AddDonationPage extends StatefulWidget {
  final String id;

  AddDonationPage({Key key, this.id}) : super(key: key);

  @override
  _AddDonationPageState createState() => _AddDonationPageState();
}

class _AddDonationPageState extends State<AddDonationPage> {
  String moreInfo, token, did;
  double proposedAmount;
  List data = List(); //edited line
  BeneficiarieTemplate templateData;
  bool isLoaded = false;
  final mainKey = GlobalKey<ScaffoldState>();
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    did = prefs.getString("did");
    print("============$did");
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
                          hintText: 'Enter Proposed Amount'),
                      onChanged: (text) {
                        proposedAmount = double.parse(text);
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
                        })
                  ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            await onSubmit(context);
          }),
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    Donation funds = new Donation(
        did: did,
        bid: widget.id,
        proposedAmount: proposedAmount,
        moreInfo: moreInfo,
        donationStatus: []);

    print(proposedAmount);
    var result = await fundDetails_helper.FundDetails().addDonation(
        HttpEndPoints.BASE_URL + HttpEndPoints.ADD_DONATION, token, funds);
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
