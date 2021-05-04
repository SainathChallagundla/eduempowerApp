import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:convert';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eduempower/models/beneficiarieDocuments.dart';
import 'package:eduempower/models/beneficiarieTemplate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';

class DocumentsPage extends StatefulWidget {
  final String id;
  @override
  createState() => DocumentsPageState();
  DocumentsPage({Key key, this.id}) : super(key: key);
}

class DocumentsPageState extends State<DocumentsPage> {
  String documentTypeSelection, token, email, name, userCategory;

  bool toEnable = false;

  bool reload = false;

  BeneficiarieDocuments data = BeneficiarieDocuments(); //edited line

  List dropdownData = [];

  final String url =
      HttpEndPoints.BASE_URL + HttpEndPoints.GET_BENEFICIARIE_DOCUMENTS;
  final txtDescController = TextEditingController();

  final globalKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    userCategory = prefs.getString("userCategory");

    BeneficiarieDocuments list = await HttpHelper()
        .getBeneficiarieDocuments(url, widget.id, token, 0, 0);
    setState(() {
      data = list;
    });
  }

  Future<void> onFileUpload() async {
    BeneficiarieDocuments list = await HttpHelper()
        .getBeneficiarieDocuments(url, widget.id, token, 0, 0);
    setState(() {
      data = list;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getInit();
    dropdownData.add("Medical");
    dropdownData.add("Educational");
    dropdownData.add("Personal");
    dropdownData.add("Dependent");
    dropdownData.add("Misc");
  }

  dispose() {
    super.dispose();
    txtDescController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Documents",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      key: globalKey,
      body: Column(
        children: [
          Container(child: IntrinsicHeight(child: fullRow(context))),
          Expanded(
            child: buildListView(data),
          ),
        ],
      ), //
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: userCategory == "contributor"
          ? FloatingActionButton(
              child: const Icon(Icons.file_upload),
              tooltip: "select a file",
              elevation: 1,
              onPressed: () {
                setState(() {
                  this.toEnable = true;
                });
              })
          : null,
    );
  }

  Widget leftSelection(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: new EdgeInsets.only(left: 5.0, top: 5.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new DropdownButton(
              hint: new Text("Select Doc Type"),
              items: dropdownData != null
                  ? dropdownData.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item.toString()),
                        value: item.toString(),
                      );
                    }).toList()
                  : null,
              onChanged: (newVal) async {
                setState(() {
                  documentTypeSelection = newVal;
                });
              },
              value: documentTypeSelection,
            ),
          ],
        ),
      ),
    );
  }

  Widget centerSelection(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: new EdgeInsets.only(left: 5.0, top: 5.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                ),
                hintText: 'Enter file name',
              ),
              controller: txtDescController,
              inputFormatters: [
                // WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9_-]"))
              ],
              onChanged: (text) {
                // name = text;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSection(BuildContext context) {
    return Container(
      padding: new EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: Text("Upload"),
            onPressed: () async {
              if (txtDescController.text == "") {
                showSnackbar(context,
                    "File description to be provided before uploading");
                // return;
              } else {
                Map<String, dynamic> resp = await submitFileUplaod();
                //submitFileUplaod().then((Map<String, dynamic> resp) {
                try {
                  var fileid = resp["fileId"][0];
                  var document = Document(
                      documentType: documentTypeSelection,
                      documentName: txtDescController.text,
                      documentId: fileid);

                  String url = HttpEndPoints.BASE_URL +
                      HttpEndPoints.ADD_BENEFICIARIE_DOCUMENT +
                      widget.id;

                  HttpHelper()
                      .submitBenificiarieDocument(url, token, document)
                      .whenComplete(onFileUpload);
                  // onFileUpload();
                } catch (e) {
                  print(e);
                }
                // );

                setState(() {
                  this.toEnable = false;
                });
              }
            },
          )
        ],
      ),
    );
  }

  Column fullRow(BuildContext context) {
    if (this.toEnable) {
      return Column(
        children: <Widget>[
          leftSelection(context),
          centerSelection(context),
          rightSection(context),
          //onSubmit,
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }
    return new Column();
  }

  Future<Map<String, dynamic>> submitFileUplaod() async {
    String url = HttpEndPoints.BASE_URL +
        "/v1/user/file?description=" +
        txtDescController.text;
    var purl = Uri.parse(url);
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    http.MultipartRequest request = http.MultipartRequest('POST', purl);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    if (!kIsWeb) {
      String filePath;
      if (result != null) {
        filePath = result.files.single.path ?? "";
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('files', filePath);
        request.files.add(multipartFile);
      }
    } else {
      var fileBytes = result.files.first.bytes;
      http.MultipartFile multipartFile = new http.MultipartFile.fromBytes(
          "files", fileBytes,
          filename: basename(result.files.single.name));
      request.files.add(multipartFile);
    }
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void showSnackbar(BuildContext context, String text) {
    globalKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  ListView buildListView(BeneficiarieDocuments data) {
    if (data != null) {
      return ListView.builder(
        itemCount: data.documents?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(data.documents[index].documentName)]),
            trailing: IconButton(
                icon: Icon(Icons.list),
                onPressed:
                    () /*async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MyWebView(
                          "Documents",
                          HttpEndPoints.BASE_URL +
                              HttpEndPoints.GET_FILE +
                              data.documents[index].documentId,
                        )));
              },*/
                    async {
                  await launch(HttpEndPoints.BASE_URL +
                      HttpEndPoints.GET_FILE +
                      data.documents[index].documentId);
                }),
          );
        },
      );
    } else {
      print("No Documents Foun ");
      return ListView();
    }
  }
}
