import 'package:eduempower/funds/editFundRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:eduempower/funds/addDonation.dart';
import 'package:eduempower/models/beneficiariefundRequests.dart'
    as bfund_requests;

class ViewFundRequestsPage extends StatefulWidget {
  final String id;
  @override
  ViewFundRequestsPageState createState() => ViewFundRequestsPageState();
  ViewFundRequestsPage({Key key, this.id}) : super(key: key);
}

class ViewFundRequestsPageState extends State<ViewFundRequestsPage> {
  String token, userCategory;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  bfund_requests.BeneficiarieFundRequests freqList;
  var url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDREQUESTS;
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    userCategory = prefs.getString("userCategory");
    print("-------------------${widget.id}");
    var details = await fundDetails_helper.FundDetails()
        .getBeneficiarieFundRequest(url, widget.id, token, 0, 0);
    setState(() {
      freqList = details;
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
      // var data = fundRequestData. ?? 0;
      return new ListView.builder(
          itemCount: freqList.fundRequest.length ?? 0,
          itemBuilder: _itemBuilder);
    } else {
      return Container(
        width: 0,
        height: 0,
      );
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
          children: _getWidgetListAll(freqList, index),
        ),
      ),
    );
  }

  List<Widget> _getWidgetListAll(
      bfund_requests.BeneficiarieFundRequests fundRequestData, int index) {
    List<Widget> listWidgets = [];

    var nameWidget = _getTextField(
        fundRequestData.fundRequest[index].fundRequired.toString(),
        "Required Amount",
        "");

    var fundingStatusWidget = _getTextField(
        fundRequestData.fundRequest[index].moreInfo, "Description", "");

    listWidgets.add(nameWidget);
    listWidgets.add(fundingStatusWidget);
    listWidgets.add(userCategory == "contributor"
        ? Container(
            width: 150.0,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: OutlinedButton(
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditFundRequestPage(
                          requiredFund: fundRequestData != null
                              ? fundRequestData.fundRequest[index].fundRequired
                              : "",
                          moreInfo: fundRequestData != null
                              ? fundRequestData.fundRequest[index].moreInfo
                              : "",
                          id: fundRequestData != null
                              ? fundRequestData.fundRequest[index].id
                              : "")),
                );
                setState(() {
                  this.reload = result ?? false;
                });
                if (result ?? false) {
                  this.getInit();
                }
              },
              child: Text("Edit Request"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red)))),
            ))
        : Container(
            width: 150.0,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: OutlinedButton(
              child: Text("Add Donation"),
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddDonationPage(
                            bid: widget.id != null ? widget.id : "",
                            frid: fundRequestData.fundRequest[index].id,
                          )),
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
    listWidgets.add(userCategory == "contributor"
        ? Container(
            width: 150.0,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: OutlinedButton(
              onPressed: () async {
                await onSubmit(context, index);
                this.getInit();
              },
              child: Text("Delete Request"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red)))),
            ))
        : Container());
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
                borderSide: new BorderSide(
                  color: Colors.orange,
                  width: 1.0,
                )),
            labelText: heading,
          ),
        ));
  }

  Future<void> onSubmit(BuildContext context, index) async {
    var result = await fundDetails_helper.FundDetails().deleteFundRequestById(
      HttpEndPoints.BASE_URL + HttpEndPoints.DELETE_FUNDREQUESTBYID,
      widget.id + "/" + freqList.fundRequest[index].id,
      token,
    );
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
