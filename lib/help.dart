import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/drawer.dart';
import 'package:package_info/package_info.dart';

class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => new HelpPageState();
}

class HelpPageState extends State<HelpPage> {

  String _projectName = "";
  String _projectAppID = "";
  String _projectVersion = "";
  String _projectCode = "";


  @override
  initState() {
    super.initState();
    getAppInfo();
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectName = packageInfo.appName;
    String projectAppID = packageInfo.packageName;
    String projectVersion = packageInfo.version;
    String projectCode = packageInfo.buildNumber;

    setState(() {
      _projectVersion = projectVersion;
      _projectCode = projectCode;
      _projectAppID = projectAppID;
      _projectName = projectName;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Help"),
      ),
      drawer: LeetDrawer(),
      body: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new ListTile (
              // leading: new Icon(Icons.help),
              title: Text(_projectName),
              // title: const Text("Help"),
              subtitle: const Text('''Wiki Leet is an application for tracking wish lists.

Usage:
  1. From the Home screen, enter items into the text input field to create a wish list
  2. Swipe items to remove them from the list
''')),
            new Container(
              height: 10,
            ),
            new AboutListTile(
              applicationName: _projectName,
              applicationVersion: _projectVersion,
              applicationLegalese: _projectAppID,
              icon: new Icon(Icons.info),
            ),
            new Container(
              height: 10,
            ),
            new ExpansionTile(
              leading: new Icon(Icons.info),
              title: const Text('Info'),
              children: <Widget>[
                new Container(
                  height: 10.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.arrow_right),
                  title: const Text('Name'),
                  subtitle: new Text(_projectName),
                ),
                new Divider(
                  height: 20.0,
                ),
                  new ListTile(
                  leading: new Icon(Icons.arrow_right),
                  title: const Text('Version Name'),
                  subtitle: new Text(_projectVersion),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.arrow_right),
                  title: const Text('Version Code'),
                  subtitle: new Text(_projectCode),
                ),
                new Divider(
                  height: 20.0,
                ),
                new ListTile(
                  leading: new Icon(Icons.arrow_right),
                  title: const Text('App ID'),
                  subtitle: new Text(_projectAppID),
                ),

              ],
            ),
          ],
        ),
      )
    );
  }
}