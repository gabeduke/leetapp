import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Leet App',
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        secondaryHeaderColor: Colors.blueGrey,

        // Define the default Font Family
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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

  final CollectionReference collectionReference =
      Firestore.instance.collection("users");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);

    print("User Name : ${user.displayName}");
    setState(() {
      displayData = "Logged in";
      appUser = googleSignIn.currentUser.email;
    });
    return user;
  }



  void _signOut() {
    googleSignIn.signOut();
    print("User signed out");
  }

  void _add() {
    try {
      setState(() {
        //datamap
        data = <String, String>{
          "name": "current user: " + googleSignIn.currentUser.displayName,
          "email": "current email: " + googleSignIn.currentUser.email,
        };

        collectionReference.document(appUser).setData(data).whenComplete(() {
          print("User Added");
        }).catchError((e) => print(e));
      });
    } catch (e) {
      print(e.toString());
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

  void _update() {
    data = <String, String>{
      "name": "updated user: " + googleSignIn.currentUser.displayName,
      "email": "updated email: " + googleSignIn.currentUser.email,
    };
    collectionReference.document(appUser).updateData(data).whenComplete(() {
      print("User Updated");
    }).catchError((e) => print(e));
  }

  void _fetch() {
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
        ),
        drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
            new DrawerHeader(
              child: new Text('Menu'),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            new ListTile(
              title: new Text('Sign In'),
              onTap: () => _signIn()
                .then((FirebaseUser user) => print(user))
                .catchError((e) => print(e)),
            ),
            new ListTile(
              title: new Text('Sign Out'),
              onTap: _signOut,
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
        ),
        body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _add,
                  child: new Text("Create"),
                  color: Theme.of(context).accentColor,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _update,
                  child: new Text("Update"),
                  color: Theme.of(context).accentColor,
                ),
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

class AboutPage extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About"),
      ),
      body: new Text("Leet App is an application that displays a database record for a given user."),
    );
  }
}