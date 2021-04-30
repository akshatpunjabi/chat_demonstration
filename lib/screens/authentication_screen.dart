import 'package:flutter/material.dart';

import '../components/firebase_authenticator.dart';
import 'otp_UI.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PinCodeVerificationScreen.context = context;
    AuthenticationFirebase.context = context;
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PinCodeVerificationScreen(),
      ),
    );
  }
}
