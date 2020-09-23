import 'package:cloud_firestore/cloud_firestore.dart';

class Stories {
  List<StoryData> file;
  String userName;
  String userImage;
  String documentID;

  Stories({this.file, this.userImage, this.userName, this.documentID});

  factory Stories.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    List<StoryData> file;
    if (data['file'] != null) {
      file = new List<StoryData>();
      data['file'].forEach((v) {
        file.add(new StoryData.fromMap(v));
      });
    }

    return Stories(file: file,userImage: data['userImage'],userName: data['userName'],documentID: snapshot.id);
  }
}

class StoryData {
  String caption;
  String source;
  String type;
  Timestamp time;

  StoryData({this.caption, this.source, this.time, this.type});

  StoryData.fromMap(Map snapshot)
      : caption = snapshot['caption'],
        source = snapshot['source'],
        time = snapshot['time'],
        type = snapshot['type'];

  toJson() {
    return {
      "caption": caption,
      "source": source,
      "time": time,
      "type": type,
    };
  }
}
