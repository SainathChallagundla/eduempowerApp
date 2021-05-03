import 'package:eduempower/funds/editFundRequest.dart';
import 'package:eduempower/models/fundRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;

class ViewFundRequestsPage extends StatefulWidget {
  final String id;
  @override
  ViewFundRequestsPageState createState() => ViewFundRequestsPageState();
  ViewFundRequestsPage({Key key, this.id}) : super(key: key);
}

class ViewFundRequestsPageState extends State<ViewFundRequestsPage> {
  String token;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  List<FundRequest> fundRequestData = List<FundRequest>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print(widget.id);
    var details = await HttpHelper().getFundRequestsByBeneficiary(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDREQUESTS,
        token,
        0,
        0,
        widget.id);
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
      return new ListView.builder(
        itemCount: fundRequestData?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.orange[300], width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        onPressed: () async {
                          bool result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditFundRequestPage(
                                    requiredFund:
                                        fundRequestData[index].fundRequired,
                                    moreInfo: fundRequestData[index].moreInfo,
                                    id: fundRequestData != null
                                        ? fundRequestData[index].id
                                        : "")),
                          );
                        },
                        icon: Icon(Icons.edit_outlined)),
                    Column(
                      children: <Widget>[
                        Text(
                          "Request Fund:${fundRequestData[index].fundRequired.toString()}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text("Info:${fundRequestData[index].moreInfo}"),
                        Text(fundRequestData[index].id)
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          await onSubmit(context, index);
                          setState(() {
                            reload = false;
                          });
                        },
                        icon: Icon(Icons.delete_forever_outlined))
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
      fundRequestData[index].id,
      token,
    );
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
