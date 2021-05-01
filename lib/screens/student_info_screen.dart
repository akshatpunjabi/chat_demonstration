import 'package:chat_demonstration/screens/teams_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

// ignore: must_be_immutable
class StudentInfoScreen extends StatefulWidget {
  String phoneNumber;
  StudentInfoScreen(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }
  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String firstName, lastName, regNo;
  final _formKey = GlobalKey<FormState>();

  final CollectionReference address =
      FirebaseFirestore.instance.collection('user_info');
  Future updateUserData() async {
    return await address.doc(loggedInUser.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'registration_number': regNo,
      'PhoneNumber': widget.phoneNumber,
      'isInstructor': false,
    });
  }

  @override
  void initState() {
    loggedInUser = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'images/data.jpeg',
              fit: BoxFit.fill,
            )),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
                        prefixIcon: Icon(Icons.perm_contact_cal),
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
                        prefixIcon: Icon(Icons.how_to_reg),
                        prefixStyle: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF7E808C),
                        ),
                        hintText: "Registration number",
                      ),
                      validator: (value) {
                        if (value.trim().length == 0) {
                          return "Please enter a registration number";
                        } else if (!isNumeric(value)) {
                          return "Please enter a valid registration number";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        regNo = value;
                      },
                    ),
                  ),
                  Card(
                    elevation: 10,
                    color: Colors.transparent,
                    child: Text(
                      widget.phoneNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      height: 70,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Processing Data')));
                              await updateUserData();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamsPage(),
                                  ));
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
