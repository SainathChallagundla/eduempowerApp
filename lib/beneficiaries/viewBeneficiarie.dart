import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:eduempower/models/beneficiarieDataFields.dart'
    as beneficiarieDataFields_model;
import 'package:flutter/material.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ViewBeneficiariePage extends StatefulWidget {
  final String id;
  @override
  createState() => _ViewBeneficiariePageState();
  ViewBeneficiariePage({Key key, this.id}) : super(key: key);
}

class _ViewBeneficiariePageState extends State<ViewBeneficiariePage> {
  String token, email, name;
  bool isLoaded = false;

  BeneficiarieDetails benediciarieData = BeneficiarieDetails();

  beneficiarieDataFields_model.BeneficiarieDataFields dataFields =
      beneficiarieDataFields_model.BeneficiarieDataFields();

  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    // print("id======================${widget.id}");
    var details = await HttpHelper().getBeneficiarieById(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIEBYID,
        widget.id,
        token);

    setState(() {
      benediciarieData = details;
      isLoaded = true;
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: Text("View Beneficiarie",
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextField(
                      enabled: false,
                      enableInteractiveSelection: false,
                      //initialValue: benediciarieData.name,
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          labelText: benediciarieData.name),
                      readOnly: true,
                      // onChanged: (text) {
                      //   name = text;
                      // },
                    ),
                    SizedBox(height: 20),
                    new Expanded(child: gridView(context, benediciarieData)),
                  ]))),
    );
  }

  Widget gridView(
      BuildContext context, BeneficiarieDetails beneficiarieDetails) {
    if (isLoaded ?? false) {
      return new GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: beneficiarieDetails?.data?.length ?? 0,
          shrinkWrap: true,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: kIsWeb ? 10.0 : 3.0),
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
                      beneficiarieDetails.data[index].header + ":",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextFormField(
                      initialValue: beneficiarieDetails.data[index].value,
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
}
