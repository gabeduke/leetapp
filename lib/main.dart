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
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
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
  String myText = null;
  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.document("myData/users");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);

    print("User Name : ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User signed out");
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "current user: " + googleSignIn.currentUser.displayName,
      "desc": "current email: " + googleSignIn.currentUser.email,
    };
    documentReference.setData(data).whenComplete(() {
      print("User Added");
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {
        myText = "User Deleted";
      });
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "updated user: " + googleSignIn.currentUser.displayName,
      "desc": "updated email: " + googleSignIn.currentUser.email,
    };
    documentReference.updateData(data).whenComplete(() {
      print("User Updated");
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['name'];
        });
      } else {
        setState(() {
          myText = "User doesn't exist";
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
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
          title: new Text("Firebase Demo"),
        ),
        body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new RaisedButton(
                  onPressed: () => _signIn()
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) => print(e)),
                  child: new Text("Sign In"),
                  color: Colors.green,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _signOut,
                  child: new Text("Sign out"),
                  color: Colors.red,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _add,
                  child: new Text("Create"),
                  color: Colors.cyan,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _update,
                  child: new Text("Update"),
                  color: Colors.cyan,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _delete,
                  child: new Text("Delete"),
                  color: Colors.cyan,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                new RaisedButton(
                  onPressed: _fetch,
                  child: new Text("Get"),
                  color: Colors.cyan,
                ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                myText == null
                    ? new Container()
                    : new Text(
                        myText,
                        style: new TextStyle(fontSize: 20),
                      ),
              ],
            )));
  }
}
