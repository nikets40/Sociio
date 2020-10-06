import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/home_screen_view.dart';
import 'package:nixmessenger/UI/views/login_view.dart';

import 'db_service.dart';
import 'navigation_service.dart';

class AuthService {
  bool registrationStarted;
  String mobileNumber;
  String verificationId;
  UserCredential userCredential;
  ConfirmationResult webSignInConfirmationResult;

  static AuthService instance = AuthService();

  AuthService({this.registrationStarted = false});

  //Handles Auth
  handleAuth(){
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting)
            return Container();

          if (snapshot.hasData) {
              return HomeScreen();
          } else {
            return LoginView();
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) async {
      FirebaseAuth.instance.signInWithCredential(authCreds).whenComplete(() => checkUserExists());
  }

  signInWithOTP(smsCode) {
    try{
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      signIn(authCreds);
    }catch(e){
      log(e.toString());
      return e;
    }

  }

  Future<void> verifyPhone(phoneNo) async {
    mobileNumber = phoneNo;
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);

  }

  verifyOTPWeb(String otp) async {
    userCredential =  await webSignInConfirmationResult.confirm(otp);
  }


  checkUserExists() async {
    final User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .get()
        .then((value) async {
      if (!value.exists) {
        await DBService.instance.createUserInDB(mobileNumber, user.uid);
        NavigationService.instance.navigateTo("profile_info");
      } else {
        if(FirebaseAuth.instance.currentUser!= null)
        DBService.instance.updateIsOnline(isOnline:true,userUID: FirebaseAuth.instance.currentUser.uid);
        NavigationService.instance.navigateToWithClearTop("home");
      }
    });
  }
}
