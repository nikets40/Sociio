import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String name;
  final String profilePicture;
  final String lastMessage;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet(
      {this.id,
      this.conversationID,
      this.lastMessage,
      this.name,
      this.profilePicture,
      this.timestamp,
      this.unseenCount});

      factory ConversationSnippet.fromFirestore(DocumentSnapshot snapshot){
        var data = snapshot.data;
        return ConversationSnippet(
          id: snapshot.documentID,
          conversationID: data["conversationID"],
          name:data["name"],
          profilePicture:data["profilePicture"],
          lastMessage: data["lastMessage"],
          unseenCount: data["unseenCount"],
          timestamp: data["timestamp"], 
        ) ;
      }
}
