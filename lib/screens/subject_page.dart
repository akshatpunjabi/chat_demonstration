import 'package:chat_demonstration/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../index.dart';
import 'assignment_page.dart';
import 'home.dart';
import 'notes_page.dart';

class SubjectPage extends StatefulWidget {
  String subjectName;
  DocumentSnapshot userData;
  SubjectPage(DocumentSnapshot userData, String subjectName) {
    this.subjectName = subjectName;
    this.userData = userData;
  }

  @override
  State<StatefulWidget> createState() => SubjectPageState();
}

class SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Image.asset('images/${widget.subjectName.toLowerCase()}.png'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(widget.subjectName, widget.userData),
                    ));
              },
              child: Text(
                "CHAT",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndexPage(),
                    ));
              },
              child: Text(
                "CALL",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        !widget.userData.data()['isInstructor']
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurpleAccent),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, HomePage.id);
                    },
                    child: Text(
                      "EXAM",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentPage(
                          widget.subjectName + "_assignment", widget.userData),
                    ));
              },
              child: Text(
                "Assignments".toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotesPage(
                          widget.subjectName + "_notes", widget.userData),
                    ));
              },
              child: Text(
                "NOTES",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
