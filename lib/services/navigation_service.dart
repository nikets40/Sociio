import 'package:flutter/material.dart';

class NavigationService{
  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService(){
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String _routeName){
    return navigationKey.currentState.pushReplacementNamed(_routeName);
  }

  Future<dynamic> navigateTo(String _routeName){
    return navigationKey.currentState.pushNamed(_routeName);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute _route){
    return navigationKey.currentState.push(_route);
  }

  Future<dynamic> navigateToWithClearTop(String _routeName){
    return navigationKey.currentState.pushNamedAndRemoveUntil(_routeName, (route) => false);
  }

   goBack(){
    return navigationKey.currentState.pop();
  }
}