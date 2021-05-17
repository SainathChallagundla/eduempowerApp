import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/donations.dart' as funds_model;
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/models/common.dart';

class ViewDonationsListPage extends StatefulWidget {
  final String title, id;
  @override
  _ViewDonationsListPageState createState() => _ViewDonationsListPageState();
  ViewDonationsListPage({Key key, this.title, this.id}) : super(key: key);
}

class _ViewDonationsListPageState extends State<ViewDonationsListPage> {
  String token, did;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  //List<funds_model.Donation> listData = [];
  List<BeneficiarieData> bdata = [];
  String token, beneficiarieName;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<funds_model.Donation> listData = [];
  var ds = funds_model.DonationStatusFields();
  //final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONS;
  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.COMMON;
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    did = prefs.getString("did");

    var list = await fundDetails_helper.FundDetails()
        .getDonationByDonar(url, token, 0, 0, widget.id);

    // var list = await fundDetails_helper.FundDetails()
    //     .getDonationByDonar(url, token, 0, 0, widget.id);
    var list = await fundDetails_helper.FundDetails().common(url, did, token);
    setState(() {
      bdata = list;
      listData = list;
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
      appBar: AppBar(
          title: Text("",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: buildcardListView(bdata),
    );
  }

  ListView buildcardListView(List<BeneficiarieData> data) {
    if (data != null) {
      return ListView.builder(
          itemCount: data?.length ?? 0, itemBuilder: _itemBuilder
          // (context, index) {
          //   return Card(
          //       margin: EdgeInsets.all(10),
          //       shape: RoundedRectangleBorder(
          //         side: new BorderSide(color: Colors.orange[300], width: 1.0),
          //         borderRadius: BorderRadius.circular(15.0),
          //       ),
          //       child: Container(
          //           padding: EdgeInsets.all(10),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   Text("Beneficiarie Name :"),
          //                   Text(bdata[index].beneficiarie.name != null
          //                       ? bdata[index].beneficiarie.name
          //                       : ""),
          //                 ],
          //               ),
          //               SizedBox(height: 20),
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   Text("Amount :"),
          //                   Text(bdata != null
          //                       ? data[index].proposedAmount.toString()
          //                       : ""),
          //                 ],
          //               ),
          //               SizedBox(height: 20),
          //               Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: <Widget>[
          //                   Text("MoreInfo :"),
          //                   Text(data != null ? data[index].moreInfo : ""),
          //                 ],
          //               ),
          //             ],
          //           )));
          // },
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
          children: _getWidgetListAll(bdata),
        ),
      ),
    );
  }

  List<Widget> _getWidgetListAll(List<BeneficiarieData> details) {
    List<Widget> listWidgets = [];

    var nameWidget = _getTextField(
        details[listWidgets.length].beneficiarie.name, "Beneficiarie Name", "");
    var donationAmount = _getTextField(
        details[listWidgets.length].proposedAmount.toString(),
        "Donated Amount",
        "");
    var currentStatus = _getTextField(
        details[listWidgets.length].currentStatus.status, "Current status", "");
    var moreInfo =
        _getTextField(details[listWidgets.length].moreInfo, "Description", "");
    listWidgets.add(nameWidget);
    listWidgets.add(donationAmount);
    listWidgets.add(currentStatus);
    listWidgets.add(moreInfo);
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
      body: buildcardListView(listData),
    );
  }

  ListView buildcardListView(List<funds_model.Donation> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.orange[300], width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Beneficiarie Name :"),
                          Text(
                              beneficiarieName != null ? beneficiarieName : ""),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Amount :"),
                          Text(data != null
                              ? data[index].proposedAmount.toString()
                              : ""),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("MoreInfo :"),
                          Text(data != null ? data[index].moreInfo : ""),
                        ],
                      ),
                    ],
                  )));
        },
      );
    } else {
      return ListView();
    }
  }
}
