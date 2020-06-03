import 'package:flutter/material.dart';
import 'package:nixmessenger/services/auth_service.dart';
import 'package:nixmessenger/services/navigation_service.dart';

class PopUpMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<int>(
      icon: Icon(Icons.more_vert),
      onSelected: (value){
        onSelected(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("New group"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("New broadcast"),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("WhatsApp Web"),
        ),
        PopupMenuItem(
          value: 4,
          child: Text("Starred messages"),
        ),
        PopupMenuItem(
          value: 5,
          child: Text("Settings"),
        ),
        PopupMenuItem(
          value: 6,
          child: Text("Logout"),
        ),
      ],
    );
  }

  onSelected(int value)async{

    switch (value){
      case 5: print("settings pressed");
              break;
      case 6:
        print("LogOut Button Pressed");
        await AuthService.instance.signOut();
        print("Logged out");

        NavigationService.instance.navigateToWithClearTop("login");
//        NavigationService.instance.navigateToRoute(MaterialPageRoute(builder: (context)=>MobileRegistration()));
        break;
      default: print("default");
    }

  }

}
