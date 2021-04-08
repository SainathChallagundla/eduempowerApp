import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class DonarFundsPage extends StatefulWidget {
  DonarFundsPage({Key key}) : super(key: key);

  @override
  _DonarFundsPageState createState() => _DonarFundsPageState();
}

class _DonarFundsPageState extends State<DonarFundsPage> {
  String _mySelection, token, email, name;
  List data = List(); //edited line
  BeneficiarieTemplate templateData;
  bool isLoaded = false;

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_TEMPLATE_NAMES;
  final mainKey = GlobalKey<ScaffoldState>();

  //Map dataList = Map();
  //List<TemplateDataFields> dataList = List<TemplateDataFields>();
  // void getInit() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = await prefs.getString("token");
  //   email = await prefs.getString("email");
  //   var list = await HttpHelper().getTemplateNames(url, token);

  //   setState(() {
  //     data = list;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //this.getInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainKey,
      resizeToAvoidBottomInset: true,
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
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Enter Amount'),
                    onChanged: (text) {
                      name = text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Mode Of Payment'),
                    onChanged: (text) {
                      name = text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'Referance No.'),
                    onChanged: (text) {
                      name = text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLines: 3,
                    decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        hintText: 'More Info'),
                    onChanged: (text) {
                      name = text;
                    },
                  ),
                  SizedBox(height: 20),
                  IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        FilePickerResult result = await FilePicker.platform
                            .pickFiles(type: FileType.any);
                        String filePath;
                        if (result != null) {
                          filePath = result.files.single.path;
                        }
                      },
                      icon: Column(children: <Widget>[
                        Icon(
                          Icons.attach_file,
                          color: Colors.orange[200],
                        ),
                      ])),
                  Text(
                    "\u{20B9}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            onSubmit(context);
          }),
    );
  }

  void onSubmit(BuildContext context) async {
    BeneficiarieDetails beneficiarieDetails = new BeneficiarieDetails(
        name: name, templateName: templateData.templateName, user: email);
    beneficiarieDetails.data = List<TemplateDataFields>();
    //beneficiarieDetails.data.addAll(dataList);
    // Give status here
    beneficiarieDetails.statusForFunding = "created";

    var result = await beneficiarieDetails_helper.BeneficiarieDetails()
        .addBenificiarieDetails(
            HttpEndPoints.BASE_URL + HttpEndPoints.ADD_BENEFICIARY_DETAILS,
            token,
            beneficiarieDetails);
    if (result.status == "success") {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }
}
