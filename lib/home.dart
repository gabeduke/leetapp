import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/drawer.dart';
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

  List<String> litems = [];
  final TextEditingController _textController = new TextEditingController();

  Map<String, String> data;
  bool isLoading = false;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

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
  void _handleSubmitted(String text) {
    _textController.clear();
    litems.add(text);
    setState(() {});
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
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder
              (
                itemCount: litems.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  final item = litems[index];

                  return Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify Widgets.
                    key: Key(item),
                    // We also need to provide a function that tells our app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from our data source.
                      setState(() {
                        litems.removeAt(index);
                      });

                      // Then show a snackbar!
                      // Scaffold.of(context)
                      //     .showSnackBar(SnackBar(content: Text("$item dismissed")));
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(title: Text('$item')),
                  );
                })
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration:
                      new InputDecoration.collapsed(hintText: "Wiki Items..")
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  )
                ),
              ]
            ),
          )
          ],
      )
            );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
