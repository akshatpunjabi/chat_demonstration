import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user_info').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text("MyClass Database"),
              ),
              body: ListView.builder(
                itemCount: snapshot.data.size,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      Center(child: Text("User Information")),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data.docs[index]
                                                .data()['firstName'] +
                                            " " +
                                            snapshot.data.docs[index]
                                                .data()['lastName']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data.docs[index]
                                                .data()['isInstructor']
                                            ? snapshot.data.docs[index]
                                                .data()['Email']
                                            : snapshot.data.docs[index]
                                                .data()['PhoneNumber']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data.docs[index]
                                                .data()['isInstructor']
                                            ? snapshot.data.docs[index]
                                                .data()['teaching_ID']
                                            : snapshot.data.docs[index]
                                                .data()['registration_number']),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/pdf.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 140,
                                child: Card(
                                  margin: EdgeInsets.all(18),
                                  elevation: 7.0,
                                  child: Center(
                                    child: Text(
                                      snapshot.data.docs[index]
                                              .data()['firstName'] +
                                          " " +
                                          snapshot.data.docs[index]
                                              .data()['lastName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
            );
        }
      },
    );
  }
}
