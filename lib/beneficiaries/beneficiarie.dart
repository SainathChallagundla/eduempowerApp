import 'package:eduempower/models/beneficiarieDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:flutter/cupertino.dart';
import 'package:eduempower/helpers/beneficiarieDetails.dart'
    as beneficiarieDetails_helper;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BeneficiariePage extends StatefulWidget {
  BeneficiariePage({Key key}) : super(key: key);

  @override
  _BeneficiariePageState createState() => _BeneficiariePageState();
}

class _BeneficiariePageState extends State<BeneficiariePage> {
  String _mySelection, token, email, name;
  List data = List(); //edited line
  BeneficiarieTemplate templateData;
  bool isLoaded = false;

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_TEMPLATE_NAMES;
  final mainKey = GlobalKey<ScaffoldState>();

  //Map dataList = Map();
  List<TemplateDataFields> dataList = List<TemplateDataFields>();
  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    var list = await HttpHelper().getTemplateNames(url, token);

    setState(() {
      data = list;
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
          title: Text("Add Beneficiarie",
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
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    // Text("Select the template"),
                    new DropdownButton(
                      items: data != null
                          ? data.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['TemplateName']),
                                value: item['TemplateName'].toString(),
                              );
                            }).toList()
                          : null,
                      hint: Text("Select a template"),
                      onChanged: (newVal) async {
                        setState(() {
                          _mySelection = newVal;
                        });
                        templateData = await HttpHelper().getTemplateData(
                            HttpEndPoints.BASE_URL + HttpEndPoints.GET_TEMPLATE,
                            _mySelection,
                            token);
                        setState(() {
                          if (templateData != null) {
                            print(templateData.templateFields[0].name);
                            isLoaded = true;
                          }
                        });
                      },
                      value: _mySelection,
                    ),
                    TextField(
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          hintText: 'Enter Patient Name'),
                      onChanged: (text) {
                        name = text;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    new Expanded(
                      child: gridView(context, templateData),
                    )
                  ]))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            onSubmit(context);
          }),
    );
  }

  // Widget rowVerify(BuildContext context, bool tobeVerified, int index) {
  //   if (tobeVerified) {
  //     return new Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           FlatButton(
  //             child: Text(
  //               "Approve",
  //               style: new TextStyle(
  //                 color: Colors.blue,
  //               ),
  //             ),
  //             onPressed: () {},
  //           ),
  //           FlatButton(
  //             child: Text(
  //               "Reject",
  //               style: new TextStyle(
  //                 color: Colors.blue,
  //               ),
  //             ),
  //             onPressed: () {},
  //           )
  //         ]);
  //   }
  //   return Container(height: 0);
  // }

  Widget gridView(BuildContext context, BeneficiarieTemplate templateData) {
    if (dataList.isEmpty) {
      if (templateData != null) {
        if (templateData.templateFields.isNotEmpty) {
          templateData.templateFields.forEach((field) {
            var itemTemplateFieldData = TemplateDataFields();
            itemTemplateFieldData.name = field.name;
            itemTemplateFieldData.required = field.required;
            itemTemplateFieldData.regex = field.regex;
            itemTemplateFieldData.header = field.header;
            itemTemplateFieldData.type = field.type;
            itemTemplateFieldData.verification = Verification(
                toBeVerified: field.verification.toBeVerified,
                verifiedBy: "", //field.verification.verifiedBy,
                status: ""); //field.verification.status);
            dataList.add(itemTemplateFieldData);
          });
        }
      }
    }
    return new GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: templateData?.templateFields?.length ?? 0,
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: kIsWeb ? 14.0 : 3.0),
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              child: SingleChildScrollView(
            child: new Container(
              alignment: Alignment.topLeft,
              margin: new EdgeInsets.all(1.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  templateData?.templateFields[index].groupHeader == null
                      ? Container()
                      : Text(
                          templateData.templateFields[index].groupHeader + ":",
                          style: TextStyle(
                            textBaseline: TextBaseline.ideographic,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: 5),
                  //: Container(),
                  TextField(
                    key: Key("${templateData.templateFields[index]..name}"),
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                          RegExp(templateData.templateFields[index].regex))
                    ],
                    maxLines: 2,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      hintText:
                          'Enter ' + templateData.templateFields[index].header,
                    ),
                    onChanged: (text) {
                      if (dataList != null && dataList.isNotEmpty) {
                        var item = dataList.where((m) {
                          return m.name ==
                              templateData.templateFields[index].name;
                        }).single;
                        item.value = text;
                      }
                    },
                  ),
                  // rowVerify(
                  //     context,
                  //     templateData
                  //         .templateFields[index].verification.toBeVerified,
                  //     index),
                ],
              ), //new Text('Item $index'),
            ),
          ));
        });
  }

  void onSubmit(BuildContext context) async {
    BeneficiarieDetails beneficiarieDetails = new BeneficiarieDetails(
        name: name, templateName: templateData.templateName, user: email);
    beneficiarieDetails.data = List<TemplateDataFields>();
    beneficiarieDetails.data.addAll(dataList);
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
