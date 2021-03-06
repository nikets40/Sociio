import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/UI/widgets/busy_overlay_widget.dart';
import 'package:nixmessenger/services/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:universal_platform/universal_platform.dart';

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

    if(!UniversalPlatform.isWeb)
    AuthService.instance.verifyPhone(widget.countryCode + widget.mobileNumber);
    super.initState();
  }

  var showLoading = false;

  @override
  Widget build(BuildContext context) {
//    verifyPhone();
    return BusyOverlay(
      show: showLoading,
      title: "Verifying OTP",
      child: Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: BackButton(
            color: Colors.green,
          ),
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
                          appContext: context,
                          length: 6,
                          keyboardType: TextInputType.number,
                          autoDismissKeyboard: false,
                          backgroundColor: Colors.transparent,
                          animationType: AnimationType.fade,
                          autoDisposeControllers: true,
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(color: Colors.white),
                          onCompleted: (val){
                            verifyNumber();
                          },
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
                       verifyNumber();
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
      ),
    );
  }
  verifyNumber()async{
    print(enteredOtp);
    setState(() {
      showLoading = true;
    });

    await AuthService.instance.signInWithOTP(enteredOtp);
    setState(() {
      showLoading = false;
    });


  }
}
