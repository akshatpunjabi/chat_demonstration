import 'package:chat_demonstration/screens/teams_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'instructor_info_screen.dart';

class InstructorLoginScreen extends StatefulWidget {
  static String email;
  static const String id = 'login_screen';
  @override
  _InstructorLoginScreenState createState() => _InstructorLoginScreenState();
}

class _InstructorLoginScreenState extends State<InstructorLoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String password;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'images/student.jpg',
              fit: BoxFit.fill,
            )),
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'images/teacher.jpg',
              fit: BoxFit.fill,
            )),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  style: TextStyle(color: Colors.white.withOpacity(.9)),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    InstructorLoginScreen.email = value;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.black54,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Enter the email address',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  style: TextStyle(color: Colors.white.withOpacity(.9)),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      fillColor: Colors.black54,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter the password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(5),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF151B21)),
                  ),
                  child: Text("LOG IN"),
                  onPressed: () async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: InstructorLoginScreen.email,
                          password: password);
                      if (user != null) {
                        var store = FirebaseFirestore.instance
                            .collection('user_info')
                            .doc(_auth.currentUser.uid);

                        store.get().then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamsPage()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InstructorInfoScreen(
                                      InstructorLoginScreen.email),
                                ));
                          }
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Please enter valid credentials.",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ));
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
