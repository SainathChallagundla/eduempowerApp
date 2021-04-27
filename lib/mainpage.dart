import 'package:flutter/material.dart';
import 'package:eduempower/home.dart';
import 'package:eduempower/bottomAppBar/search.dart';
import 'package:eduempower/home2.dart';
import 'package:eduempower/funds/viewfunds.dart';
import 'package:convex_bottom_navigation/convex_bottom_navigation.dart';

class MainPage extends StatefulWidget {
  String title;
  @override
  _MainPageState createState() => _MainPageState();
  MainPage({Key key, this.title}) : super(key: key);
}

class _MainPageState extends State<MainPage> {
  String token, email, name, userType, userCategory;
  int _currentIndex = 0;
  List<Widget> _children = [];
  final mainKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _children = [
      MyHomePage(),
      HomePage(),
      ViewFundsPage(),
      Search(),
      // Settings()
    ];
    return homeScaffold();
  }

  Scaffold homeScaffold() {
    return Scaffold(
      key: mainKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBottomNavigationBar() {
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

        TabData(
          icon: const Icon(Icons.sports_handball_sharp),
          title: "donar",
        ),

        TabData(
          icon: const Icon(Icons.search),
          title: "search",
        ),
        // TabData(
        //   icon: const Icon(Icons.settings),
        //   title: "settings",
        // ),
      ],
      onTabChangedListener: (int position) {
        setState(() {
          _currentIndex = position;
        });
      },
    );
  }

  // void onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }
}
