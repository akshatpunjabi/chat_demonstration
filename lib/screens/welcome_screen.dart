import 'package:chat_demonstration/screens/student_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'isntructor_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstructorLoginScreen(),
                    ));
              },
              child: Container(
                width: 200,
                alignment: Alignment.center,
                child: Text("Login as Instructor"),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
            },
            child: Container(
              width: 200,
              alignment: Alignment.center,
              child: Text("Login as a Student"),
            ),
          )
        ],
      ),
    );
  }
}
