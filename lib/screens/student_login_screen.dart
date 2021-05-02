import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:string_validator/string_validator.dart';

import '../components/otp_functionality.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String number;
  String input;
  double deviceHeight, deviceWidth;
  bool length = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height / 891.4285714285714;
    deviceWidth = MediaQuery.of(context).size.width / 411.42857142857144;
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'images/student.jpg',
              fit: BoxFit.fill,
            )),
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 280 * deviceHeight,
              ),
              SizedBox(
                height: 60 * deviceHeight,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Please Sign In/Sign up to your account',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 90 * deviceHeight,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val.trim().length != 10 || !isNumeric(val)) {
                        return "Please enter a valid number";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      input = value;
                      if (value.length == 10 && isNumeric(input)) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          length = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      counterText: '',
                      prefixIcon: Icon(
                        Icons.call,
                        color: Colors.teal[700],
                      ),
                      prefixText: '+91  ',
                      prefixStyle: TextStyle(
                        fontSize: 15,
                      ),
                      labelText: "Enter your Mobile Number",
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40 * deviceWidth,
                    16.0 * deviceHeight, 40 * deviceWidth, 16 * deviceHeight),
                child: Material(
                  elevation: 6.0,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        number = '+91$input';
                        registerUser(number, context,scaffoldKey);
                      }
                    },
                    minWidth: 20.0,
                    height: 42.0,
                    child: Text(
                      'Continue'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
