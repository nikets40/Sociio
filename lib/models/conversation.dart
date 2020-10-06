import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List members;
  final List<Messages> messages;
  final String ownerID;


  Conversation({this.id, this.members, this.messages, this.ownerID});

  factory Conversation.fromFirestore(DocumentSnapshot snapshot){
        var data = snapshot.data();
        List<Messages> messages;
        if (data['messages'] != null) {
          messages = new List<Messages>();
          data['messages'].forEach((v) {
            messages.add(new Messages.fromMap(v));
          });
        }
        return Conversation(
          id: snapshot.id,
          messages: messages,
          members: data['members'],
          ownerID: data['ownerId'],
        ) ;
      }
}

class Messages{
  final String message;
  final String senderID;
  final String type;
  final Timestamp time;

  Messages({this.message, this.senderID, this.type, this.time});

  factory Messages.fromMap(Map messageData){
    return Messages(
      time: messageData['timestamp'],
      message: messageData['message'],
      senderID: messageData['senderID'],
      type: messageData['type']
    );
  }
}
