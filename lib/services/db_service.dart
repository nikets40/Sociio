import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nixmessenger/models/conversation.dart';
import 'package:nixmessenger/models/story_model.dart';
import 'package:nixmessenger/models/user_model.dart';

class DBService {
  static DBService instance = DBService();
  static User user = FirebaseAuth.instance.currentUser;

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
    try {
      return await _db.collection(_userCollections).doc(user.uid).update({
        "name": _name,
        "profilePicture": profilePicture,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateTyping()async{}

  Future updateLastSeen() async {
    try {
      return await _db
          .collection(_userCollections)
          .doc(user.uid)
          .update({"lastSeen": DateTime.now()});
    } catch (e) {
      log("error updating last seen:- $e");
    }
  }

  Stream<UserData> fetchUserData({String userUid}) {
    var _ref = _db.collection(_userCollections).doc(userUid ?? user.uid);
    print(_ref);
    var stream =
        _ref.snapshots().map((_snapshot) => UserData.fromFirestore(_snapshot));
    return stream;
  }

  Stream<List<UserData>> fetchAllUsers() {
    var _ref = _db.collection(_userCollections);
    return _ref.snapshots().map((snapshot) =>
        snapshot.docs.map((_doc) => UserData.fromFirestore(_doc)).toList());
  }

  Future<void> updateIsOnline(bool isOnline) async {
    try {
      // log("updating status");

      return await _db
          .collection(_userCollections)
          .doc(user.uid)
          .update({"isOnline": isOnline});
    } catch (e) {
      print(e);
    }
  }

  Future<void> createOrGetConversation(
      {String recipientID,
      Future<void> onSuccess(String _conversationID)}) async {
    var _ref = _db.collection("Conversations");
    var _userConversationRef = _db
        .collection(_userCollections)
        .doc(user.uid)
        .collection("Conversations");
    try {
      var conversation = await _userConversationRef.doc(recipientID).get();
      if (conversation.exists)
        return onSuccess(conversation.data()['conversationID']);
      else {
        var _conversationRef = _ref.doc();
        await _conversationRef.set({
          "members": [user.uid, recipientID],
          "owner": [user.uid],
        });
        await createNewChat(user.uid, recipientID, _conversationRef.id);
        return onSuccess(_conversationRef.id);
      }
    } catch (e) {
      log("error retrieving conversation :-$e");
    }
  }

  Future createNewChat(userID, recipientID, conversationID) async {
    await _db
        .collection(_userCollections)
        .doc(userID)
        .collection("Conversations")
        .doc(recipientID)
        .set({
      "conversationID": conversationID,
      "unseenCount": 0,
    });
    await _db
        .collection(_userCollections)
        .doc(recipientID)
        .collection("Conversations")
        .doc(userID)
        .set({
      "conversationID": conversationID,
      "unseenCount": 0,
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db.collection("Users").doc(_userID).collection("Conversations");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Stories>> getAllStories(String _userID) {
    var _ref = _db.collection("Stories");
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Stories.fromFirestore(_doc);
      }).toList();
    });
  }

  Future<void> resetUnseenCount(String documentID) async {
    return await _db
        .collection("Users")
        .doc(user.uid)
        .collection("Conversations")
        .doc(documentID)
        .update({"unseenCount": 0});
  }

  Future<void> sendMessage(
      String message, String conversationID, recipientID) async {
    try {
      var messageTime = DateTime.now();
      Map messageDetails =  {
        "message": message,
        "senderID": user.uid,
        "timestamp":messageTime,
        "type": "text"
      };
      await _db.collection("Conversations").doc(conversationID).update({
        "messages": FieldValue.arrayUnion([
          messageDetails
        ])
      });
      updateLastMessageDetails(recipientID, messageDetails);
    } catch (e) {
      print("Error while Sending Message $e");
    }
  }

  Future updateLastMessageDetails(recipientID,Map messageDetails) async {
    try {
      await _db.collection(_userCollections).doc(user.uid).collection("Conversations").doc(recipientID).update({
        "lastMessage": messageDetails['message'],
        "timestamp": messageDetails['timestamp'],
        "type": messageDetails['type'],
        "unseenCount": FieldValue.increment(1),
      });

      await _db.collection(_userCollections).doc(recipientID).collection("Conversations").doc(user.uid).update({
        "lastMessage": messageDetails['message'],
        "timestamp": messageDetails['timestamp'],
        "type": messageDetails['type'],
        "unseenCount": FieldValue.increment(1),
      });

    } catch (e) {}
  }
}
