import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/drawer.dart';

class HelpPage extends StatelessWidget {


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
              title: Text("Wiki Leet"),
              // title: const Text("Help"),
              subtitle: const Text('''Wiki Leet is an application for tracking wish lists.

Usage:
  1. From the Home screen, enter items into the text input field to create a wish list
  2. Swipe items to remove them from the list
''')),
          ],
        ),
      )
    );
  }
}