import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/main.dart';
import 'package:app/text.dart';
import 'package:app/drawer.dart';
import 'package:app/const.dart';
import 'package:app/settings.dart';

class MyHomePage extends StatefulWidget {

  final String currentUserId;

  MyHomePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {

  String displayData;
  String appUser;
  Map<String, String> data;
  StreamSubscription<DocumentSnapshot> subscription;
  bool isLoading = false;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  final CollectionReference collectionReference =
      Firestore.instance.collection("users");

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });
    await googleSignIn.signOut();
    this.setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  void _delete() {
    collectionReference.document(appUser).delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {
        displayData = "User Deleted";
      });
    }).catchError((e) => print(e));
  }

  void _fetch() {
    try {
      collectionReference.document(appUser).get().then((datasnapshot) {
        if (datasnapshot.exists) {
          setState(() {
            displayData = datasnapshot.data['name'];
          });
        } else {
          setState(() {
            displayData = "User doesn't exist";
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      appUser = googleSignIn.currentUser.email;
      subscription = collectionReference.document(appUser).snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          displayData = datasnapshot.data['email'];
        });
      }
    });
    } catch (e) {
      print(e.toString());
      setState(() {
        displayData = "Please log in";
      });
    };

  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("LeetApp"),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
        drawer: LeetDrawer(),
        body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _delete,
                  child: new Text("Delete"),
                  color: Theme.of(context).accentColor,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _fetch,
                  child: new Text("Get"),
                  color: Theme.of(context).accentColor,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                RaisedButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditScreen()),
                    );
                  },
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                displayData == null
                    ? new Container()
                    : new Text(
                        displayData,
                        style: new TextStyle(fontSize: 20),
                      ),
              ],
            )));
  }
}