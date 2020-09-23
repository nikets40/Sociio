import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/home_screen_view.dart';
import 'package:nixmessenger/UI/views/login_view.dart';
import 'package:nixmessenger/UI/views/profile_info.dart';
import 'package:nixmessenger/services/auth_service.dart';
import 'package:nixmessenger/services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

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
