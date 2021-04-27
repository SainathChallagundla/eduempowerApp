import 'package:flutter/material.dart';
import 'package:eduempower/contributorHomePage.dart';
import 'package:convex_bottom_navigation/convex_bottom_navigation.dart';
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
        bottomNavigationBar: _contributorBottomNavigationBar());
  }

  Widget _contributorBottomNavigationBar() {
    return ConvexBottomNavigation(
      barBackgroundColor: Colors.orange[300],
      activeIconColor: Colors.black,
      inactiveIconColor: Colors.grey,
      textColor: Colors.black,
      bigIconPadding: 15.0,
      //circleSize: CircleSize.SMALL,
      //smallIconPadding: 10.0,
      //circleColor: Colors.black,
      tabs: [
        TabData(
          icon: const Icon(Icons.home_outlined),
          title: "home",
        ),
        TabData(
          icon: const Icon(Icons.person_pin_circle_sharp),
          title: "beneficiary",
        ),
      ],
      onTabChangedListener: (int position) {
        setState(() {
          _currentIndex = position;
        });
      },
    );
  }
}