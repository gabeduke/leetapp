
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About"),
      ),
      drawer: LeetDrawer(),
      body: new Text("Leet App is an application that displays a database record for a given user."),
    );
  }
}
