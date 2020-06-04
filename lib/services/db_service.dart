import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nixmessenger/models/conversation.dart';

class DBService {
  static DBService instance = DBService();

  Firestore _db;

  DBService() {
    _db = Firestore.instance;
  }

  String _userCollections = "Users";

  Future<void> createUserInDB(String _number, String _uid) async {
    try {
      return await _db.collection(_userCollections).document(_uid).setData({
        "number": _number,
        "lastSeen": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProfileInfoInDB(String _name, String profilePicture) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    try {
      return await _db
          .collection(_userCollections)
          .document(user.uid)
          .updateData({
        "name": _name,
        "profilePicture": profilePicture,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref =
        _db.collection("Users").document(_userID).collection("Conversations");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Future<void> resetUnseenCount(String documentID)async{
final FirebaseUser user = await FirebaseAuth.instance.currentUser();
return await _db.collection("Users").document(user.uid).collection("Conversations").document(documentID).updateData({"unseenCount":0});


  }

  Future<void> sendMessage(String message, String conversationID) async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      return await _db
          .collection("Conversations")
          .document(conversationID)
          .updateData({
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
