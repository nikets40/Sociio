
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/UI/widgets/mobile_number_field_widget.dart';
import 'package:universal_platform/universal_platform.dart';

import 'otp_verification_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  String countryCode = '+91';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter your Mobile Number",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  verticalSpace(10),
                  Text(
                    "Use your 10 Digit Mobile number to Sign In",
                    style: TextStyle(color: Colors.white),
                  ),
                  verticalSpace(40),
                  MobileNumberField(
                    initialSelection: countryCode,
                    countryCode: (code) {
                      countryCode = code;
                    },
                    textEditingController: _textEditingController,
                  ),
                  verticalSpace(20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth(context) * 0.95,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () {
                      print(_textEditingController.text);
                      confirmationDialog();
                    },
                    child: Text(
                      "Continue",
                      textScaleFactor: 1.3,
                    ),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  dialogContent({color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "We will be verifying the phone number: \n",
          textAlign: TextAlign.start,
          style: TextStyle(color: color),
        ),
        Text(
          "$countryCode ${_textEditingController.text}",
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          "\nIs this OK, or would you like to edit the number?",
          textAlign: TextAlign.start,
          style: TextStyle(color: color),
        )
      ],
    );
  }

  void confirmationDialog() {
    // flutter defined function

    if (UniversalPlatform.isIOS)
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content:
          dialogContent(color: Colors.black),
          actions: [
            CupertinoDialogAction(
              child: new Text("Edit",),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: new Text("OK",),
              onPressed: () {

                Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>
                            OtpVerification(countryCode:countryCode,
                              mobileNumber: _textEditingController.text,)));
              },
            ),
          ],
        );
      },
    );

    else
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: Colors.white12,
            content: dialogContent(color: Colors.white.withOpacity(0.8)),
            actions: [
              FlatButton(
                child: new Text(
                  "Edit",
                  textScaleFactor: 1.2,
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("OK", textScaleFactor: 1.2,style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>
                            OtpVerification(countryCode:countryCode,
                              mobileNumber: _textEditingController.text,)));
                },
              ),
            ],
          );
        },
      );
  }
}
