import 'package:chat_demonstration/home.dart';
import 'package:chat_demonstration/index.dart';
import 'package:chat_demonstration/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class DSAPage extends StatefulWidget {
  static const String id = 'dsa_page';
  @override
  State<StatefulWidget> createState() => DSAState();
}

class DSAState extends State<DSAPage> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen("DSA"),
                      ));
                },
                child: Text("CHAT")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndexPage(),
                      ));
                },
                child: Text("CALL")),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomePage.id);
                },
                child: Text("EXAM")),
          ]),
    ));
  }
}
