import 'package:eduempower/beneficiaries/documents.dart';
import 'package:eduempower/beneficiaries/editBeneficiarie.dart';
import 'package:eduempower/beneficiaries/viewBeneficiarie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/funds.dart' as funds_model;
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/funds/viewFundDetails.dart';

class ViewFundsPage extends StatefulWidget {
  final String title;
  @override
  ViewFundsPageState createState() => ViewFundsPageState();
  ViewFundsPage({Key key, this.title}) : super(key: key);
}

class ViewFundsPageState extends State<ViewFundsPage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  final mainKey = GlobalKey<ScaffoldState>();

  List<funds_model.Fund> data = List<funds_model.Fund>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDS;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var list = await fundDetails_helper.FundDetails()
        .getFundsByDonar(url, token, 0, 0, email);

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

  ListView buildListView(List<funds_model.Fund> data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
              // title: Text(data != null ? data[index].name : ""),
              title: Text(data[index].donorEmail ?? ""),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                    onPressed: () async {
                      print(data[index].id);
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFundDetailsPage(
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
