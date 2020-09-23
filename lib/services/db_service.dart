import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nixmessenger/models/conversation.dart';
import 'package:nixmessenger/models/story_model.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db;

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollections = "Users";

  Future<void> createUserInDB(String _number, String _uid) async {
    try {
      return await _db.collection(_userCollections).doc(_uid).set({
        "number": _number,
        "lastSeen": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProfileInfoInDB(String _name, String profilePicture) async {
    final User user =  FirebaseAuth.instanceFor().currentUser;
    try {
      return await _db
          .collection(_userCollections)
          .doc(user.uid)
          .update({
        "name": _name,
        "profilePicture": profilePicture,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref =
        _db.collection("Users").doc(_userID).collection("Conversations");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Stories>> getAllStories(String _userID) {
    var _ref =
    _db.collection("Stories");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Stories.fromFirestore(_doc);
      }).toList();
    });
  }

  Future<void> resetUnseenCount(String documentID)async{
    final User user =  FirebaseAuth.instanceFor().currentUser;
return await _db.collection("Users").doc(user.uid).collection("Conversations").doc(documentID).update({"unseenCount":0});


  }

  Future<void> sendMessage(String message, String conversationID) async {
    try {
      final User user =  FirebaseAuth.instanceFor().currentUser;
      return await _db
          .collection("Conversations")
          .doc(conversationID)
          .update({
        "messages": FieldValue.arrayUnion([
          {
            "message": message,
            "senderID": user.uid,
            "timestamp": DateTime.now(),
            "type": "text"
          }
        ])
      });
    } catch (e) {
      print("Error while Sending Message $e");
    }
  }
}
