import 'package:chat_demonstration/screens/student_info_screen.dart';
import 'package:chat_demonstration/screens/student_login_screen.dart';
import 'package:chat_demonstration/screens/teams_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/authentication_screen.dart';
import '../screens/otp_UI.dart';

void registerUser(String mobile, BuildContext context) {
  FirebaseAuth _auth = FirebaseAuth.instance;
//  final _codeController = TextEditingController();
//  String smsCode;

  _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 59),
      verificationCompleted: (AuthCredential authCredential) {
        //PinCodeVerificationScreen.timer.cancel();
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          User user = result.user;
          //user.updatePhoneNumberCredential(authCredential);
          var store =
              FirebaseFirestore.instance.collection('user_info').doc(user.uid);

          store.get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TeamsPage()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentInfoScreen(mobile)));
            }
          });
        }).catchError((e) {});
      },
      verificationFailed: (FirebaseAuthException authException) {
        String text;
        if (authException.message ==
                'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]' ||
            authException.message ==
                'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code].') {
          text = "Please enter a valid Mobile Number.";
        } else
          text =
              'You have reached the limit of OTP texts for this Mobile Number.Try a different Number or wait for a few hours.';
        LoginScreenState.scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            text,
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 4),
        ));
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        PinCodeVerificationScreen.verId = verificationId;
        PinCodeVerificationScreen.phoneNumber = mobile;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthenticationScreen(),
            ));
        //show dialog to take input from the user
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Time out");
      });
}
