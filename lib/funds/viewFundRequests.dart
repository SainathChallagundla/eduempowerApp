import 'package:eduempower/funds/editFundRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:eduempower/models/beneficiariefundRequests.dart';
import 'package:eduempower/funds/addDonation.dart';

class ViewFundRequestsPage extends StatefulWidget {
  final String id;
  @override
  ViewFundRequestsPageState createState() => ViewFundRequestsPageState();
  ViewFundRequestsPage({Key key, this.id}) : super(key: key);
}

class ViewFundRequestsPageState extends State<ViewFundRequestsPage> {
  String token, userCategory, donarId;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  //List<FundRequest> fundRequestData = [];
  BeneficiarieFundRequests fundRequestData =
      BeneficiarieFundRequests(); //edited line

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    userCategory = prefs.getString("userCategory");
    donarId = prefs.getString("did");

    var details =
        await fundDetails_helper.FundDetails().getBeneficiarieFundRequest(
      HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDREQUESTS,
      widget.id,
      token,
      0,
      0,
    );

    //"all");
    setState(() {
      fundRequestData = details;
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
          centerTitle: true,
          title: Text("Fund ReQuests",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: gridView(context),
    );
  }

  Widget gridView(BuildContext context) {
    if (isLoaded == true) {
      var data = fundRequestData?.fundRequests?.length ?? 0;
      return new ListView.builder(
        itemCount: data ?? 0, //fundRequestData?.fundRequest?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.orange[300], width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Fund Requested :"),
                            Text(
                              fundRequestData.fundRequests[index].fundRequired
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Info :"),
                            Text(
                              fundRequestData.fundRequests[index].moreInfo,
                            ),
                          ],
                        ),
                      ],
                    ),
                    userCategory == "contributor"
                        ? IconButton(
                            onPressed: () async {
                              print(fundRequestData.fundRequests[index].id);
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditFundRequestPage(
                                        requiredFund: fundRequestData != null
                                            ? fundRequestData
                                                .fundRequests[index]
                                                .fundRequired
                                            : "",
                                        moreInfo: fundRequestData != null
                                            ? fundRequestData
                                                .fundRequests[index].moreInfo
                                            : "",
                                        id: fundRequestData != null
                                            ? fundRequestData
                                                .fundRequests[index].id
                                            : "")),
                              );
                              setState(() {
                                this.reload = result ?? false;
                              });
                              if (result ?? false) {
                                this.getInit();
                              }
                            },
                            icon: Icon(Icons.edit_outlined))
                        : Container(),
                    userCategory == "contributor"
                        ? IconButton(
                            onPressed: () async {
                              await onSubmit(context, index);
                            },
                            icon: Icon(Icons.delete_forever_outlined))
                        : TextButton.icon(
                            onPressed: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddDonationPage(
                                        id: fundRequestData.id != null
                                            ? fundRequestData.id
                                            : "")),
                              );
                              setState(() {
                                this.reload = result;
                              });
                              if (result == true) {
                                this.getInit();
                              }
                            },
                            label: Text(" Add Donation"),
                            icon: const Text(
                              ("  \u{20B9}"),
                              style: TextStyle(fontSize: 20),
                            )),
                    SizedBox(height: 20),
                  ]));
        },
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Future<void> onSubmit(BuildContext context, index) async {
    var result = await fundDetails_helper.FundDetails().deleteFundRequestById(
      HttpEndPoints.BASE_URL + HttpEndPoints.DELETE_FUNDREQUESTBYID,
      widget.id + "/" + fundRequestData.fundRequests[index].id,
      token,
    );
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
