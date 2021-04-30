import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                InstructorLoginScreen.email = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the email address'),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter the password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              child: Text("LOG IN"),
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: InstructorLoginScreen.email, password: password);
                  if (user != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InstructorInfoScreen(InstructorLoginScreen.email),
                        ));
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
    );
  }
}
