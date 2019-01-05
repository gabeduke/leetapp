import 'package:app/about.dart';
import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeetDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LeetDrawerState();
  }
}

class LeetDrawerState extends State<LeetDrawer> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  void getSharedPref() async {
      prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
            new DrawerHeader(
              child: new Text('Menu'),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new MyHomePage(currentUserId: prefs.getString('id'),)),
                );},
            ),
            new ListTile(
              leading: new Icon(Icons.info),
              title: new Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new AboutPage()),
                );},
            ),
          ],
        ),
        );
  }
}