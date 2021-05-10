import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/donations.dart' as funds_model;
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/funds/viewDonationDetails.dart';

class ViewDonationsListPage extends StatefulWidget {
  final String title, id;
  @override
  _ViewDonationsListPageState createState() => _ViewDonationsListPageState();
  ViewDonationsListPage({Key key, this.title, this.id}) : super(key: key);
}

class _ViewDonationsListPageState extends State<ViewDonationsListPage> {
  String token;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<funds_model.Donation> data = []; //edited line

  //final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONS;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    var list = await fundDetails_helper.FundDetails().getDonationByDonar(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONATIONS,
        token,
        0,
        0,
        widget.id);

    setState(() {
      data = list;
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
      body: buildListView(data),
    );
  }

  ListView buildListView(List<funds_model.Donation> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
              // title: Text(data != null ? data[index].name : ""),
              title: Text(
                data[index].proposedAmount.toString() ?? "",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                    onPressed: () async {
                      print(data[index].proposedAmount);
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDonationsPage(
                                id: data != null ? data[index].id : "")),
                      );
                      setState(() {
                        this.reload = result;
                      });
                      if (result == true) {
                        this.getInit();
                      }
                    },
                    icon: Icon(Icons.view_list_outlined))
              ]));
        },
      );
    } else {
      print("no data....");
      return ListView();
    }
  }
}
