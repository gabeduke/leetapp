import 'package:app/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeetDrawer extends StatelessWidget {
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
              title: new Text('About'),
              onTap: () { Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new AboutPage()),
                );},
            ),
          ],
        ),
        );
  }
}