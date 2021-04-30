import 'package:chat_demonstration/dsa.dart';
import 'package:flutter/material.dart';

class TeamsPage extends StatefulWidget {
  static const String id = 'teams_page';
  @override
  State<StatefulWidget> createState() => TeamsState();
}

class TeamsState extends State<TeamsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.lightBlue,
            body: SafeArea(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DSAPage(),
                                  ));
                            },
                            child: Image(
                              image: AssetImage('images/dsa.jpg'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              print('elephant clicked');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DSAPage(),
                                  ));
                            },
                            child: Image(
                              image: AssetImage('images/daa.jpg'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DSAPage(),
                                  ));
                              print('elephant clicked');
                            },
                            child: Image(
                              image: AssetImage('images/dbs.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            onPressed: () {},
                            child: Image(
                              image: AssetImage('images/dsd.jpg'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {},
                            child: Image(
                              image: AssetImage('images/ost.jpg'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {},
                            child: Image(
                              image: AssetImage('images/coa.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
