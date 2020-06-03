
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

const List<String> messages  =[
"Red is greener than purple, for sure.",
"Carol drank the blood as if she were a vampire.",
"The tart lemonade quenched her thirst, but not her longing.",
"I really want to go to work, but I am too sick to drive.",
"The green tea and avocado smoothie turned out exactly as would be expected.",
"I like to leave work after my eight-hour tea-break.",
"You're unsure whether or not to trust him, but very thankful that you wore a turtle neck.",
"I want more detailed information.",
"Fluffy pink unicorns are a popular status symbol among macho men.",
"It had been sixteen days since the zombies first attacked.",
"She hadn't had her cup of coffee, and that made things all the worse.",
"At that moment he wasn't listening to music, he was living an experience.",
"You bite up because of your lower jaw.",
"Smoky the Bear secretly started the fires.",
];



const List names = [
 "Dong Scarborough",
 "Alonso Bergan",
 "Loura Deborde",
 "Cora Mariani",
 "Liza Lavelle",
 "Tenisha Vernon",
 "Nam Fleagle",
 "Gerri Nolley",
 "Sanford Emmons",
 "Lorene Sauve",
 "Shiloh Magyar",
 "Vincenzo Speck",
 "Carlee Picken",
 "Nelida Slee",
 "Belinda Mclaughin",
 "Lenora Roses",
 "Rebeca Rittenhouse",
 "Eunice Dalessandro",
 "Lynsey Laliberte",
 "Hans Mcleod",
];
