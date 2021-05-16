import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/donations.dart' as funds_model;
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';

class ViewDonationsListPage extends StatefulWidget {
  final String title, id;
  @override
  _ViewDonationsListPageState createState() => _ViewDonationsListPageState();
  ViewDonationsListPage({Key key, this.title, this.id}) : super(key: key);
}

class _ViewDonationsListPageState extends State<ViewDonationsListPage> {
  String token, beneficiarieName;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<funds_model.Donation> listData = [];
  var ds = funds_model.DonationStatusFields();
  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONS;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    var list = await fundDetails_helper.FundDetails()
        .getDonationByDonar(url, token, 0, 0, widget.id);

    setState(() {
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
