import 'package:flutter/material.dart';
import 'package:eduempower/contributorHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduempower/home2.dart';

class ContributorMainPage extends StatefulWidget {
  String title;
  @override
  _ContributorMainPageState createState() => _ContributorMainPageState();
  ContributorMainPage({Key key, this.title}) : super(key: key);
}

class _ContributorMainPageState extends State<ContributorMainPage> {
  String token, email, name, userType, userCategory;
  int _currentIndex = 0;
  List<Widget> _children = [];
  final mainKey = GlobalKey<ScaffoldState>();

  void getInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name");
    email = prefs.getString("email");
    userCategory = prefs.getString("userCategory");
  }

  @override
  void initState() {
    getInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _children = [MyHomePage(), ContributorHomePage()];
    return homeScaffold();
  }

  Scaffold homeScaffold() {
    return Scaffold(
        key: mainKey,
        resizeToAvoidBottomInset: false,
        body: Container(child: _children[_currentIndex]),
        bottomNavigationBar: getBottomNavigationBar());
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
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
