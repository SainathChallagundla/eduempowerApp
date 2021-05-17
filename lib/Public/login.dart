import 'package:eduempower/donarMainPage.dart';
import 'package:eduempower/contributorMainPage.dart';
import 'package:eduempower/public/passwordReset.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:eduempower/public/register.dart';
import 'package:eduempower/models/user.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController emailEditingContrller = TextEditingController();
  TextEditingController passwordEditingContrller = TextEditingController();
  final mainKey = GlobalKey<ScaffoldState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Edu Empower",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Logofont',
                fontWeight: FontWeight.bold,
                fontSize: 40)),
        TextField(
          autofocus: true,
          obscureText: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          controller: emailEditingContrller,
          decoration: InputDecoration(
              labelText: "Email",
              hintText: "Email",
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.orange,
                      style: BorderStyle.solid))),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          autofocus: false,
          obscureText: _isObscure,
          keyboardType: TextInputType.text,
          controller: passwordEditingContrller,
          decoration: InputDecoration(
              labelText: "Password",
              hintText: "Password",
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1,
                      color: Colors.orange,
                      style: BorderStyle.solid)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off))),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              onPressed: onSubmit,
              color: Colors.orange,
              child: Text("Login"),
              // ),
            ),
            RaisedButton(
              onPressed: () {
                passwordEditingContrller.text = "";
                emailEditingContrller.text = "";
              },
              color: Colors.orange,
              child: Text("Reset"),
              // ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordReset(
                      email: emailEditingContrller.text ?? "",
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    mainKey.currentState.showSnackBar(new SnackBar(
                        content: Text("Password Reset Successful"),
                        duration: Duration(milliseconds: 1000)));
                  } else {
                    mainKey.currentState.showSnackBar(new SnackBar(
                        content: Text("Password Reset Failed"),
                        duration: Duration(milliseconds: 1000)));
                  }
                  // Run the code here using the value
                });
              },
              color: Colors.orange,
              child: Text("Forgot Password"),
              // ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ExpandablePanel(
          collapsed: null,
          header: Text("Register as Contributor"),
          expanded: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ButtonTheme(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserRegister(
                            userCategory: "contributor",
                            userType: "individual"),
                      ),
                    ).then((value) {
                      if (value == true) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Successful"),
                            duration: Duration(milliseconds: 1000)));
                      } else {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Failed"),
                            duration: Duration(milliseconds: 1000)));
                      }
                      // Run the code here using the value
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                  //height: 30,
                  child: Text("Register Individual"),
                ),
              ),
              ButtonTheme(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserRegister(
                            userCategory: "contributor",
                            userType: "organization"),
                      ),
                    ).then((value) {
                      if (value == true) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Successful"),
                            duration: Duration(milliseconds: 1000)));
                      } else {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Failed"),
                            duration: Duration(milliseconds: 1000)));
                      }
                      // Run the code here using the value
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                  //height: 30,
                  child: Text("Register Organization"),
                ),
              ),
            ],
          ),
          //tapHeaderToExpand: true,
          //hasIcon: true,
        ),
        SizedBox(
          height: 10,
        ),
        ExpandablePanel(
          collapsed: null,
          header: Text("Register as Donar"),
          expanded: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ButtonTheme(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserRegister(
                            userCategory: "donar", userType: "individual"),
                      ),
                    ).then((value) {
                      if (value == true) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Successful"),
                            duration: Duration(milliseconds: 1000)));
                      } else {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Failed"),
                            duration: Duration(milliseconds: 1000)));
                      }
                      // Run the code here using the value
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                  //height: 30,
                  child: Text("Register Individual"),
                ),
              ),
              ButtonTheme(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserRegister(
                            userCategory: "donar", userType: "organization"),
                      ),
                    ).then((value) {
                      if (value == true) {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Successful"),
                            duration: Duration(milliseconds: 1000)));
                      } else {
                        mainKey.currentState.showSnackBar(new SnackBar(
                            content: Text("User Registration Failed"),
                            duration: Duration(milliseconds: 1000)));
                      }
                      // Run the code here using the value
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.orange,
                  child: Text("Register Organization"),
                ),
              ),
            ],
          ),
          //tapHeaderToExpand: true,
          //hasIcon: true,
        ),
      ],
    );
    return Scaffold(
      key: mainKey,
      body: Container(
        alignment: AlignmentDirectional.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 120.0,
              bottom: 24.0), //EdgeInsets.all(24),
          child: Container(
            child: column,
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        mainKey.currentState.showSnackBar(SnackBar(
          content: Text("There is no netwrok connection"),
          duration: Duration(milliseconds: 1000),
        ));
      }

      UserLogIn user = new UserLogIn(
          email: emailEditingContrller.text,
          password: passwordEditingContrller.text);
      var result = await HttpHelper().post(
          HttpEndPoints.BASE_URL + HttpEndPoints.SIGN_IN,
          body: user.toMap());

      if (result.httpStatus == 200 && result.status == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userFetch = await HttpHelper().fetchUser(emailEditingContrller.text,
            HttpEndPoints.BASE_URL + HttpEndPoints.GET_USER, result.token);
        await prefs.setString("token", result.token);
        await prefs.setString("name", userFetch.name);
        await prefs.setString("email", userFetch.email);
        await prefs.setString("mobile", userFetch.mobile);
        await prefs.setString("userCategory", userFetch.userCategory);
        await prefs.setString("userType", userFetch.userType);

        var userCategory = prefs.getString("userCategory");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => userCategory == "donar"
                    ? DonarMainPage(
                        title: "Edu EmPower",
                      )
                    : ContributorMainPage(
                        title: "Edu EmPower",
                      )));
      } else if (result.httpStatus == 400) {
        var snackbar = SnackBar(
          content: Text(result.message.toString()),
          duration: Duration(milliseconds: 1000),
        );
        mainKey.currentState.showSnackBar(snackbar);
      }
    } on SocketException catch (exp) {
      mainKey.currentState.showSnackBar(SnackBar(
        content: Text("Something went wrong with the connection"),
        duration: Duration(milliseconds: 1000),
      ));
    }
  }
}
