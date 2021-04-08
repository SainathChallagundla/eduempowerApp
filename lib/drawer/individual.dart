import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/models/individual.dart' as individual_model;
import 'package:eduempower/helpers/individual.dart' as individual_helper;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualPage extends StatefulWidget {
  // In the constructor, require a Todo.
  IndividualPage({
    Key key,
  }) : super(key: key);

  @override
  IndividualPageState createState() => IndividualPageState();
}

class IndividualPageState extends State<IndividualPage> {
  bool loggedIn = false;
  String token, email, name;
  bool isLoaded = false;
  String _occupation,
      _moreInfo,
      _address,
      _state,
      _city,
      _country,
      _pinCode,
      _socialMedia;

  //Future<individual_model.Individual> individual;
  individual_model.Individual individual;
  final formKey = GlobalKey<FormState>();
  final mainKey = GlobalKey<ScaffoldState>();

  final String url = HttpEndPoints.BASE_URL + HttpEndPoints.GET_INDIVIDUAL;
  //final storage = new FlutterSecureStorage();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("token");
    email = await prefs.getString("email");
    //token = await storage.read(key: "token");
    //email = await storage.read(key: "email");
    var item =
        await individual_helper.Individual().getIndividual(url, email, token);
    setState(() {
      individual = item;
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
      resizeToAvoidBottomInset: false,
      key: mainKey,
      appBar: AppBar(
          title: Text("User Profile",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: Padding(
          padding: EdgeInsets.all(10.0), child: formIndividualBy(individual)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            onSubmit();
          }),
      //formIndividual()),
    );
  }

  Widget formIndividual() {
    return FutureBuilder<individual_model.Individual>(
        future: individual_helper.Individual()
            .getIndividual(url, email, token), //individual,
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
                  initialValue: snapshot.data?.occupation,
                  decoration: InputDecoration(
                    labelText: "Occupation:",
                  ),
                  validator: (str) =>
                      str.length <= 2 ? "Not a Valid Occupation!" : null,
                  onSaved: (str) => _occupation = str,
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

  Widget formIndividualBy(individual_model.Individual individual) {
    if (isLoaded) {
      return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              readOnly: true,
              autocorrect: false,
              initialValue: individual?.user?.email ?? "",
              decoration: InputDecoration(
                labelText: "Email:",
              ),
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.occupation,
              decoration: InputDecoration(
                labelText: "Occupation:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Occupation!" : null,
              onSaved: (str) => _occupation = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.moreInfo ?? "",
              decoration: InputDecoration(
                labelText: "More Information:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Information!" : null,
              onSaved: (str) => _moreInfo = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.address ?? "",
              decoration: InputDecoration(
                labelText: "Address:",
              ),
              validator: (str) =>
                  str.length <= 5 ? "Not a Valid Address!" : null,
              onSaved: (str) => _address = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.city ?? "",
              decoration: InputDecoration(
                labelText: "City:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid City!" : null,
              onSaved: (str) => _city = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.state ?? "",
              decoration: InputDecoration(
                labelText: "State:",
              ),
              validator: (str) => str.length <= 2 ? "Not a Valid State!" : null,
              onSaved: (str) => _state = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.country ?? "",
              decoration: InputDecoration(
                labelText: "Country:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid Country!" : null,
              onSaved: (str) => _country = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.pinCode ?? "",
              decoration: InputDecoration(
                labelText: "Pin/Zip Code:",
              ),
              validator: (str) =>
                  str.length <= 2 ? "Not a Valid PinCode!" : null,
              onSaved: (str) => _pinCode = str,
            ),
            TextFormField(
              autocorrect: false,
              initialValue: individual?.socialMedia ?? "",
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
      individual_model.Individual _individual = new individual_model.Individual(
          id: individual.id,
          occupation: _occupation,
          moreInfo: _moreInfo,
          address: _address,
          city: _city,
          state: _state,
          country: _country,
          pinCode: _pinCode,
          socialMedia: _socialMedia,
          user: new individual_model.UserDetails(email: email),
          status: "Active");
      var result = await individual_helper.Individual().updateIndividual(
          HttpEndPoints.BASE_URL + HttpEndPoints.UPDATE_INDIVIDUAL,
          individual.id,
          token,
          _individual);
      if (result.status == "success") {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
    }
  }
}
