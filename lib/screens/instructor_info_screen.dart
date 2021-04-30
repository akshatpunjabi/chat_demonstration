import 'package:chat_demonstration/screens/otp_UI.dart';
import 'package:chat_demonstration/screens/student_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

// ignore: must_be_immutable
class InstructorInfoScreen extends StatefulWidget {
  String email;
  InstructorInfoScreen(String email) {
    this.email = email;
  }
  @override
  _InstructorInfoScreenState createState() => _InstructorInfoScreenState();
}

class _InstructorInfoScreenState extends State<InstructorInfoScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String firstName, lastName, teachID;
  final _formKey = GlobalKey<FormState>();

  final CollectionReference address =
      FirebaseFirestore.instance.collection('instructor_user_info');
  Future updateUserData() async {
    return await address.doc(loggedInUser.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'teaching_ID': teachID,
      'Email': widget.email,
    });
  }

  @override
  void initState() {
    loggedInUser = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter the information"),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    counterText: '',
                    prefixIcon: Icon(Icons.perm_identity),
                    prefixStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7E808C),
                    ),
                    hintText: "First name",
                  ),
                  validator: (value) {
                    if (!isAlpha(value)) {
                      return "Please enter a valid name.";
                    } else if (value.trim().length == 0) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    firstName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    counterText: '',
                    prefixIcon: Icon(Icons.perm_identity),
                    prefixStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7E808C),
                    ),
                    hintText: "Last name",
                  ),
                  validator: (value) {
                    if (value.trim().length == 0) {
                      return "Please enter a name";
                    } else if (!isAlpha(value)) {
                      return "Please enter a valid name.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    lastName = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.perm_identity),
                    prefixStyle: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF7E808C),
                    ),
                    hintText: "Teaching ID",
                  ),
                  validator: (value) {
                    if (value.trim().length == 0) {
                      return "Please enter a Teaching Id";
                    } else if (!isNumeric(value)) {
                      return "Please enter a Teaching Id";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    teachID = value;
                  },
                ),
              ),
              Text(
                widget.email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                      await updateUserData();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoScreen(
                                  PinCodeVerificationScreen.phoneNumber)));
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          )),
    );
  }
}
