import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/models/organization.dart' as organization_model;
import 'package:eduempower/helpers/organization.dart' as organization_helper;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrganizationPage extends StatefulWidget {
  // In the constructor, require a Todo.
  OrganizationPage({
    Key key,
  }) : super(key: key);

  @override
  OrganizationPageState createState() => OrganizationPageState();
}

class OrganizationPageState extends State<OrganizationPage> {
  bool loggedIn = false;
  String token, email, name;
  bool isLoaded = false;
  String _orgName,
      _website,
      _moreInfo,
      _address,
      _state,
      _city,
      _country,
      _pinCode,
      _socialMedia;

  //Future<organization_model.Individual> individual;
  organization_model.Organization organization;
  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_ORGANIZATION;
  final storage = new FlutterSecureStorage();

  void getInit() async {
    token = await storage.read(key: "token");
    email = await storage.read(key: "email");
    var item = await organization_helper.Organization()
        .getOrganization(url, email, token);
    setState(() {
      organization = item;
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
      appBar: AppBar(
          title: Text("Organization Profile",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: formOrganizationBy(organization)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          onSubmit();
        },
      ), //formIndividual()),
    );
  }

  Widget formOrganization() {
    return FutureBuilder<organization_model.Organization>(
        future: organization_helper.Organization()
            .getOrganization(url, email, token), //individual,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }
          return Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.user?.email ?? "",
                  decoration: InputDecoration(
                    labelText: "Email:",
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.webSite,
                  decoration: InputDecoration(
                    labelText: "WebSite:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid WebSite!" : null,
                  onSaved: (str) => _website = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.moreInfo ?? "",
                  decoration: InputDecoration(
                    labelText: "More Information:",
                  ),
                  validator: (str) =>
                      str.length <= 5 ? "Not a Valid Information!" : null,
                  onSaved: (str) => _moreInfo = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.address ?? "",
                  decoration: InputDecoration(
                    labelText: "Address:",
                  ),
                  validator: (str) =>
                      str.length <= 5 ? "Not a Valid Address!" : null,
                  onSaved: (str) => _address = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.city ?? "",
                  decoration: InputDecoration(
                    labelText: "City:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid City!" : null,
                  onSaved: (str) => _city = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.state ?? "",
                  decoration: InputDecoration(
                    labelText: "State:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid State!" : null,
                  onSaved: (str) => _state = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.country ?? "",
                  decoration: InputDecoration(
                    labelText: "Country:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid Country!" : null,
                  onSaved: (str) => _country = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.pinCode ?? "",
                  decoration: InputDecoration(
                    labelText: "Pin/Zip Code:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid PinCode!" : null,
                  onSaved: (str) => _pinCode = str,
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: snapshot.data?.socialMedia ?? "",
                  decoration: InputDecoration(
                    labelText: "SocialMedia:",
                  ),
                  validator: (str) =>
                      str.length <= 5 ? "Not a Valid SocialMedia!" : null,
                  onSaved: (str) => _socialMedia = str,
                ),
              ],
            ),
          );
        });
  }

  Widget formOrganizationBy(organization_model.Organization organization) {
    if (isLoaded) {
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              readOnly: true,
              autocorrect: false,
              initialValue: organization?.user?.email ?? "",
              decoration: InputDecoration(
                labelText: "Email:",
              ),
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.name,
              decoration: InputDecoration(
                labelText: "Organization Name:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid WebSite!" : null,
              onSaved: (str) => _orgName = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.webSite,
              decoration: InputDecoration(
                labelText: "WebSite:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid WebSite!" : null,
              onSaved: (str) => _website = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.moreInfo ?? "",
              decoration: InputDecoration(
                labelText: "More Information:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Information!" : null,
              onSaved: (str) => _moreInfo = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.address ?? "",
              decoration: InputDecoration(
                labelText: "Address:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Address!" : null,
              onSaved: (str) => _address = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.city ?? "",
              decoration: InputDecoration(
                labelText: "City:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid City!" : null,
              onSaved: (str) => _city = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.state ?? "",
              decoration: InputDecoration(
                labelText: "State:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid State!" : null,
              onSaved: (str) => _state = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.country ?? "",
              decoration: InputDecoration(
                labelText: "Country:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Country!" : null,
              onSaved: (str) => _country = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.pinCode ?? "",
              decoration: InputDecoration(
                labelText: "Pin/Zip Code:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid PinCode!" : null,
              onSaved: (str) => _pinCode = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: organization?.socialMedia ?? "",
              decoration: InputDecoration(
                labelText: "SocialMedia:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid SocialMedia!" : null,
              onSaved: (str) => _socialMedia = str,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void onSubmit() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      organization_model.Organization _organization =
          new organization_model.Organization(
              id: organization.id,
              webSite: _website,
              name: _orgName,
              moreInfo: _moreInfo,
              address: _address,
              city: _city,
              state: _state,
              country: _country,
              pinCode: _pinCode,
              socialMedia: _socialMedia,
              user: new organization_model.UserDetails(email: email),
              status: "Active");
      var result = await organization_helper.Organization().updateOrganization(
          HttpEndPoints.BASE_URL + HttpEndPoints.UPDATE_ORGANIZATION,
          organization.id,
          token,
          _organization);
      if (result.status == "success") {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }
  }
}
