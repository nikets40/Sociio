import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nixmessenger/models/conversation.dart';
import 'package:nixmessenger/models/conversation_snipped.dart';
import 'package:nixmessenger/models/story_model.dart';
import 'package:nixmessenger/models/user_model.dart';

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
        "profilePicture": "https://firebasestorage.googleapis.com/v0/b/messaging-72809.appspot.com/o/default-user-image.png?alt=media&token=62a4ba19-f650-4891-90e1-35c8ba749d47",
        "isOnline": true,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProfileInfoInDB({String name, String profilePicture, userUid}) async {
    try {
      return await _db.collection(_userCollections).doc(userUid).update({
        "name": name,
        "profilePicture": profilePicture,
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateTyping() async {}

  Future updateLastSeen({userUID}) async {
    try {
      return await _db
          .collection(_userCollections)
          .doc(userUID)
          .update({"lastSeen": DateTime.now()});
    } catch (e) {
      log("error updating last seen:- $e");
    }
  }

  Stream<UserData> fetchUserData({String userUid}) {
    try {
      var _ref = _db.collection(_userCollections).doc(userUid);
      var stream = _ref
          .snapshots()
          .map((_snapshot) => UserData.fromFirestore(_snapshot));
      return stream;
    } catch (e) {
      return null;
    }
  }

  Stream<List<UserData>> fetchAllUsers() {
    try {
      var _ref = _db.collection(_userCollections);
      return _ref.snapshots().map((snapshot) =>
          snapshot.docs.map((_doc) => UserData.fromFirestore(_doc)).toList());
    } catch (e) {
      return e;
    }
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    try {
      var _ref =
          _db.collection("Users").doc(_userID).collection("Conversations");
      return _ref.snapshots().map((_snapshot) {
        return _snapshot.docs.map((_doc) {
          return ConversationSnippet.fromFirestore(_doc);
        }).toList();
      });
    } catch (e) {
      print(e);
      return e;
    }
  }

  Stream<List<Stories>> getAllStories(String _userID) {
    try {
      var _ref = _db.collection("Stories");
      return _ref.snapshots().map((_snapshot) {
        return _snapshot.docs.map((_doc) {
          return Stories.fromFirestore(_doc);
        }).toList();
      });
    } catch (e) {
      return e;
    }
  }

  Stream<Conversation> fetchChat(String conversationID) {
    try {
      var _ref = _db.collection("Conversations").doc(conversationID);
      return _ref.snapshots().map((event) => Conversation.fromFirestore(event));
    } catch (e) {
      return e;
    }
  }

  Future<void> updateIsOnline({bool isOnline, userUID}) async {
    try {
      return await _db
          .collection(_userCollections)
          .doc(userUID)
          .update({"isOnline": isOnline});
    } catch (e) {
      print(e);
    }
  }

  Future<void> createOrGetConversation(
      {String recipientID,
      Future<void> onSuccess(String _conversationID), userUID}) async {
    var _ref = _db.collection("Conversations");
    var _userConversationRef = _db
        .collection(_userCollections)
        .doc(userUID)
        .collection("Conversations");
    try {
      var conversation = await _userConversationRef.doc(recipientID).get();
      if (conversation.exists)
        return onSuccess(conversation.data()['conversationID']);
      else {
        var _conversationRef = _ref.doc();
        await _conversationRef.set({
          "members": [userUID, recipientID],
          "ownerId": userUID,
        });
        await createNewChat(userUID, recipientID, _conversationRef.id);
        return onSuccess(_conversationRef.id);
      }
    } catch (e) {
      log("error retrieving conversation :-$e");
    }
  }

  Future createNewChat(userID, recipientID, conversationID) async {
    try {
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
    } catch (e) {
      return null;
    }
  }

  Future<void> resetUnseenCount({String documentID,userUID}) async {

    try{
      return await _db
          .collection("Users")
          .doc(userUID)
          .collection("Conversations")
          .doc(documentID)
          .update({"unseenCount": 0});
    }catch(e){
      log("error in resetting unseen count $e");
      return null;
    }

  }

  Future<void> sendMessage({String message, String conversationID, recipientID,
      String type,senderID}) async {
    log("sending new Message");
    try {
      var messageTime = DateTime.now();
      Map messageDetails = {
        "message": (message),
        "senderID": senderID,
        "timestamp": messageTime,
        "type": type ?? "text"
      };
      await _db.collection("Conversations").doc(conversationID).update({
        "messages": FieldValue.arrayUnion([messageDetails])
      });
      updateLastMessageDetails(recipientID, messageDetails,senderID);
    } catch (e) {
      print("Error while Sending Message $e");
    }
  }

  Future updateLastMessageDetails(recipientID, Map messageDetails,userUID) async {
    try {
      await _db
          .collection(_userCollections)
          .doc(userUID)
          .collection("Conversations")
          .doc(recipientID)
          .update({
        "lastMessage": messageDetails['message'],
        "timestamp": messageDetails['timestamp'],
        "type": messageDetails['type'],
        // "unseenCount": FieldValue.increment(1),
      });

      await _db
          .collection(_userCollections)
          .doc(recipientID)
          .collection("Conversations")
          .doc(userUID)
          .update({
        "lastMessage": messageDetails['message'],
        "timestamp": messageDetails['timestamp'],
        "type": messageDetails['type'],
        "unseenCount": FieldValue.increment(1),
      });
    } catch (e) {}
  }
}
