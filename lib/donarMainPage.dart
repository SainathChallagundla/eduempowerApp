import 'package:eduempower/funds/viewfunds.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/donarHomePage.dart';
import 'package:eduempower/home2.dart';

class DonarMainPage extends StatefulWidget {
  String title;
  @override
  _DonarMainPageState createState() => _DonarMainPageState();
  DonarMainPage({Key key, this.title}) : super(key: key);
}

class _DonarMainPageState extends State<DonarMainPage> {
  String token, email, name, userType, userCategory;
  int _currentIndex = 0;
  List<Widget> _children = [];
  final mainKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _children = [MyHomePage(), DonarHomePage(), ViewFundsPage()];
    return homeScaffold();
  }

  Scaffold homeScaffold() {
    return Scaffold(
      key: mainKey,
      resizeToAvoidBottomInset: false,
      body: Container(child: _children[_currentIndex]),
      bottomNavigationBar: getBottomNavigationBar(),
      //bottomNavigationBar: _BottomNavigationBar()
    );
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      unselectedLabelStyle:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      backgroundColor: Colors.orange[300],
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped, // new
      currentIndex: _currentIndex, // new
      items: [
        new BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.group),
          title: Text('Beneficiaries'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.money),
          title: Text('Your Donations'),
        ),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
