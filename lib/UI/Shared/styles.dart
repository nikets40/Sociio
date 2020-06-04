
import 'package:flutter/material.dart';



screenWidth(context){
 return MediaQuery.of(context).size.width;
}

screenHeight(context){
 return MediaQuery.of(context).size.height;
}

verticalSpace(double space){
 return SizedBox(height: space,);
}

horizontalSpace(double space){
 return SizedBox(width: space,);
}


const TextStyle TabBarTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.white,
);





