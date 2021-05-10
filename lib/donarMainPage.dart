import 'package:eduempower/funds/viewDonations.dart';
import 'package:eduempower/helpers/httphelper.dart';
import 'package:flutter/material.dart';
import 'package:eduempower/donarHomePage.dart';
import 'package:eduempower/home2.dart';
import 'package:eduempower/helpers/fundDetails.dart' as for_donarid;
import 'package:shared_preferences/shared_preferences.dart';

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
  var donarid;
  void getInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    email = prefs.getString("email");
    var _donarid = await for_donarid.FundDetails().getDonarId(
        HttpEndPoints.BASE_URL + HttpEndPoints.GET_DONARID + email, token);
    setState(() {
      donarid = _donarid.id;
      print("==============donarid$donarid");
    });
    await prefs.setString("did", donarid);
  }

  @override
  void initState() {
    getInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      MyHomePage(),
      DonarHomePage(),
      ViewDonationsListPage(id: donarid)
    ];
    return homeScaffold();
  }

  Scaffold homeScaffold() {
    return Scaffold(
      key: mainKey,
      resizeToAvoidBottomInset: false,
      body: Container(child: _children[_currentIndex]),
      bottomNavigationBar: getBottomNavigationBar(),
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
