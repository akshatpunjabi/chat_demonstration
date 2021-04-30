import 'package:chat_demonstration/screens/otp_UI.dart';
import 'package:chat_demonstration/screens/student_info_screen.dart';
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    InfoScreen(PinCodeVerificationScreen.phoneNumber)));
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
