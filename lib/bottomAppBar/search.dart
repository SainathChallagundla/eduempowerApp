import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key, this.email}) : super(key: key);
  final String email;

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text("Search",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Logofont',
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      body: Container(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[]),
          )),
    );
  }
}
