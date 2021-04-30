import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:string_validator/string_validator.dart';

import '../components/firebase_authenticator.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  static String verId;
  static Timer timer;
  static String phoneNumber;
  static BuildContext context;

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  double deviceHeight, deviceWidth;
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController()
    ..text = "";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool timeout = false;
  bool length = false;

  void _getFutureBool() {
    Future.delayed(const Duration(seconds: 60), () {
      setState(() {
        timeout = true;
      });
    });
  }

  bool correct = true;
  bool correct1 = true;

  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    PinCodeVerificationScreen.timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            setState(() {
              _start = 0;
              timer.cancel();
            });
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
        },
      ),
    );
  }

  @override
  void initState() {
    initializeGesture();
    errorController = StreamController<ErrorAnimationType>();
    timeout = false;
    _getFutureBool();
    startTimer();
    super.initState();
  }

  void initializeGesture() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        resend(PinCodeVerificationScreen.phoneNumber);
        setState(() {
          _start = 60;
          timeout = false;
        });
        _getFutureBool();
        startTimer();
      };
  }

  void resend(String mobile) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 59),
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() {
            PinCodeVerificationScreen.verId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print("Time out");
        });
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height / 891.4285714285714;
    deviceWidth = MediaQuery.of(context).size.width / 411.42857142857144;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            PinCodeVerificationScreen.timer.cancel();
            Navigator.of(PinCodeVerificationScreen.context).pop();
          },
          iconSize: 30,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40 * deviceHeight),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset(
                  "images/otp.png",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 8 * deviceHeight),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0 * deviceHeight),
                child: Text(
                  '   Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 30.0 * deviceWidth, vertical: 8 * deviceHeight),
                child: RichText(
                  text: TextSpan(
                      text: "    Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: PinCodeVerificationScreen.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20 * deviceHeight,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0 * deviceHeight,
                        horizontal: 30 * deviceWidth),
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50 * deviceHeight,
                        inactiveColor: Colors.blue,
                        selectedColor: !correct1 ? Colors.red : Colors.green,
                        activeColor: !correct1 ? Colors.red : Colors.green,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.grey[200],
                        fieldWidth: 40 * deviceWidth,
                        activeFillColor: Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      onCompleted: (v) {},
                      onChanged: (value) {
                        currentText = value;
                        if (currentText.length == 6) {
                          setState(() {
                            length = true;
                          });
                        } else {
                          if (length) {
                            setState(() {
                              length = false;
                            });
                          }
                          setState(() {
                            correct1 = true;
                          });
                        }
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return false;
                      },
                      appContext: null,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0 * deviceWidth),
                child: Text(
                  !correct1 ? "Incorrect code entered. Try again." : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20 * deviceHeight,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                        text: " RESEND",
                        recognizer: timeout ? onTapRecognizer : null,
                        style: TextStyle(
                            color:
                                timeout ? Colors.green : Colors.green.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ]),
              ),
              SizedBox(
                height: 4 * deviceHeight,
              ),
              Center(
                  child: Text(
                _start != 0
                    ? 'Wait for $_start seconds to resend the code.'
                    : '',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              )),
              SizedBox(
                height: 10 * deviceHeight,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 16.0 * deviceHeight,
                    horizontal: 30 * deviceWidth),
                child: ButtonTheme(
                  height: 50 * deviceHeight,
                  child: FlatButton(
                    onPressed: (length && isNumeric(currentText))
                        ? () async {
                            correct = await AuthenticationFirebase.otpVerify(
                                verId: PinCodeVerificationScreen.verId,
                                code: currentText);
                            if (correct) {
                              PinCodeVerificationScreen.timer.cancel();
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Success!"),
                                duration: Duration(seconds: 2),
                              ));
                            }
                            if (!(correct)) {
                              errorController.add(ErrorAnimationType.shake);
                              setState(() {
                                correct1 = correct;
                              });
                            }
                          }
                        : null,
                    child: Center(
                        child: Text(
                      (length && isNumeric(currentText))
                          ? "VERIFY".toUpperCase()
                          : 'Enter OTP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                  color: (length && isNumeric(currentText))
                      ? Colors.green
                      : Colors.green.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(
                height: 16 * deviceHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                  FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20 * deviceHeight,
              ),
              Text(
                '      *Tap anywhere on the screen if you\'re unable to input the code.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
