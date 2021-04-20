import 'package:eduempower/models/funds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/funds.dart' as funds_model;
import 'package:eduempower/helpers/fundDetails.dart' as fundDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';

class ViewFundDetailsPage extends StatefulWidget {
  final String title;
  @override
  ViewFundDetailsPageState createState() => ViewFundDetailsPageState();
  ViewFundDetailsPage({Key key, this.title}) : super(key: key);
}

class ViewFundDetailsPageState extends State<ViewFundDetailsPage> {
  String token, email, name, userType, userCategory;
  bool reload = false;
  bool isLoaded = false;

  final mainKey = GlobalKey<ScaffoldState>();
  funds_model.Fund fundData = Fund();

  List<funds_model.Fund> data = List<funds_model.Fund>(); //edited line

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_FUNDS;

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    name = prefs.getString("name");
    userType = prefs.getString("userType");
    userCategory = prefs.getString("userCategory");
    var details =
        await fundDetails_helper.FundDetails().getFunds(url, token, 0, 0);

    setState(() {
      data = details;
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
      body: gridView(context, data),
    );
  }

  Widget gridView(BuildContext context, List<funds_model.Fund> data) {
    if (isLoaded ?? false) {
      return new GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data?.length ?? 0,
          shrinkWrap: true,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 3.0),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              child: new Container(
                alignment: Alignment.topLeft,
                margin: new EdgeInsets.all(1.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    // Expanded(
                    //     flex: 1,
                    // child:
                    Text(
                      "",
                      //data[index].header + ":",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextFormField(
                      //initialValue: beneficiarieDetails.data[index].value,
                      readOnly: true,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
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
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFundDetailsPage()),
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
