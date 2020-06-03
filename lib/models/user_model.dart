
class User{
  String number;
  DateTime lastSeen;
  String profileImage;

  User({this.number, this.lastSeen, this.profileImage});

  User.fromMap(Map snapshot):
    number = snapshot['number'],
    lastSeen = snapshot['lastSeen'],
    profileImage = snapshot['profileImage'];

  toJson(){
    return {
      "number": number,
      "lastSeen": lastSeen,
      "profileImage": profileImage,
    };
  }



}