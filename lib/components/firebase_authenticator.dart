import 'package:chat_demonstration/screens/otp_UI.dart';
import 'package:chat_demonstration/screens/student_info_screen.dart';
import 'package:chat_demonstration/screens/teams_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationFirebase {
  static BuildContext context;
  static Future<bool> otpVerify({String verId, String code}) async {
    AuthCredential _credential;
    bool correct;
    FirebaseAuth auth = FirebaseAuth.instance;
    code = code.trim();
    _credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: code);
    await auth.signInWithCredential(_credential).then((UserCredential result) {
      Future.delayed(const Duration(seconds: 1), () {
        var store = FirebaseFirestore.instance
            .collection('user_info')
            .doc(auth.currentUser.uid);

        store.get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TeamsPage()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentInfoScreen(
                        PinCodeVerificationScreen.phoneNumber)));
          }
        });
      });

      correct = true;
    }).catchError((e) {
      correct = false;
    });
    if (correct)
      return true;
    else
      return false;
  }
}
