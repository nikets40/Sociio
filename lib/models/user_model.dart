
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  String number;
  String userID;
  Timestamp lastSeen;
  String profilePicture;
  String name;
  bool isOnline;
  String status;

  UserData({this.number,this.name, this.lastSeen, this.profilePicture, this.isOnline, this.status, this.userID});

   factory UserData.fromMap(Map snapshot){
     return UserData(
         number : snapshot['number'],
         lastSeen : snapshot['lastSeen'],
         name :snapshot['name'],
         profilePicture : snapshot['profilePicture'],
         status: snapshot['status'],
         isOnline: snapshot['isOnline']
     );
   }

  toJson(){
    return {
      "number": number,
      "lastSeen": lastSeen,
      "profileImage": profilePicture,
      "name":name,
      "status":status,
    };
  }

  factory UserData.fromFirestore(DocumentSnapshot snapshot){
     var data = snapshot.data();
     return UserData(
         number : data['number'],
         lastSeen : data['lastSeen'],
         userID: snapshot.id,
         name :data['name'],
         profilePicture : data['profilePicture'],
         status: data['status'],
         isOnline: data['isOnline']

     );
  }

}