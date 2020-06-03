import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/home_screen_view.dart';
import 'package:nixmessenger/UI/views/login_view.dart';
import 'package:nixmessenger/UI/views/profile_info.dart';
import 'package:nixmessenger/services/auth_service.dart';
import 'package:nixmessenger/services/navigation_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nix Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          canvasColor: Colors.black,
          appBarTheme: AppBarTheme(
              color: Colors.black,
              centerTitle: false,
              elevation: 0,
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Colors.white),
              actionsIconTheme: IconThemeData(color: Colors.white))),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      navigatorKey: NavigationService.instance.navigationKey,
      home: AuthService.instance.handleAuth(),
      routes: {
        "login": (BuildContext context) => LoginView(),
        "home": (BuildContext context) => HomeScreen(),
        "profile_info": (BuildContext context) => ProfileInfoView(),
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
