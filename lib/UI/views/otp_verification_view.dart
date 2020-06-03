import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/services/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerification extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;

  OtpVerification({@required this.mobileNumber, @required this.countryCode});

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String enteredOtp;
  bool isResendActive = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    AuthService.instance.verifyPhone(widget.countryCode + widget.mobileNumber);
    super.initState();
  }

  var showLoading = false;

  @override
  Widget build(BuildContext context) {
//    verifyPhone();
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: Colors.green,
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Verify Mobile",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  verticalSpace(10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text:
                            "Waiting to automatically detect an SMS sent to\n",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                              text:
                                  "${widget.countryCode} ${widget.mobileNumber}. ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16)),
                          TextSpan(
                              text: "Wrong Number?",
                              style: TextStyle(color: Colors.blue))
                        ]),
                  ),
                  verticalSpace(20),
                  SizedBox(
                      width: screenWidth(context),
                      child: PinCodeTextField(
                        length: 6,
                        obsecureText: false,
                        textInputType: TextInputType.number,
                        autoDismissKeyboard: false,
                        backgroundColor: Colors.transparent,
                        animationType: AnimationType.fade,
                        autoDisposeControllers: true,
                        animationDuration: Duration(milliseconds: 300),
                        onChanged: (value) {
                          setState(() {
                            enteredOtp = value;
                          });
                        },
                      )),
                  verticalSpace(10),
                  Text(
                    "Enter 6-digit code",
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.white60),
                  ),
                  verticalSpace(40),
                  Center(
                    child: FlatButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sync,
                            size: 28,
                            color: isResendActive ? Colors.green : Colors.grey,
                          ),
                          horizontalSpace(10),
                          Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontSize: 16,
                                color: isResendActive
                                    ? Colors.white70
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth(context),
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () {
                      print(enteredOtp);
                      setState(() {
                        showLoading = true;
                      });
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

                    AuthService.instance.signInWithOTP(enteredOtp);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      "Verify OTP",
                      textScaleFactor: 1.3,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
