import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nixmessenger/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/views/chats_screen_view.dart';
import 'package:nixmessenger/UI/widgets/chats_list_tile_widget.dart';
import 'package:nixmessenger/UI/widgets/status_widget.dart';
import 'package:nixmessenger/models/conversation_snipped.dart';
import 'package:nixmessenger/services/db_service.dart';

import '../widgets/status_widget.dart';

class ChatsTab extends StatefulWidget {
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  Random random = Random();

  String user;

  List images = [
    "https://www.mordeo.org/files/uploads/2019/04/Iron-Man-In-Avengers-Endgame-4K-Ultra-HD-Mobile-Wallpaper-950x1689.jpg",
    "https://wallpapercave.com/wp/wp5285600.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTHhGEsiXv48d7MIMfpS0FbCiTvTjO6Q3JjWg&usqp=CAU"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: chatsList()),
          ),
        ),
      ],
    );
  }

  chatsList() {
    return StreamBuilder<List<ConversationSnippet>>(
        stream: DBService.instance.getUserConversations(user),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var chats = snapshot.data;
          chats.removeWhere((element) => element?.timestamp == null);

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 100.0, top: 0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              chats.sort((a,b)=>b.timestamp.toDate().compareTo(a.timestamp.toDate()));
              return StreamBuilder<UserData>(
                stream: DBService.instance.fetchUserData(userUid: chats[index].id),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatsScreen(
                                  conversationID: chats[index].conversationID,
                                  otherUserID: chats[index].id,
                                  myID: user)));
                      DBService.instance.resetUnseenCount(documentID:chats[index].id,userUID: FirebaseAuth.instance.currentUser.uid);
                    },
                    child: ChatsListTile(
                      isOnline: snapshot.data.isOnline,
                      name: snapshot?.data?.name??snapshot?.data?.number,
                      image: snapshot.data.profilePicture,
                      dateTimeLastMessage:
                      timeago.format(chats[index]?.timestamp?.toDate(),locale: 'en'),
                      lastMessage: chats[index]?.lastMessage ?? "",
                      unReadMessages: chats[index].unseenCount,
                      isChatMuted: random.nextBool(),
                    )
                  );
                  return Container();
                }
              );
            },
          );
        });
  }

  randomDate() {
    String date;
    if (random.nextBool())
      date = DateFormat('dd MMM').format(mockDate(DateTime(2020)));
    else
      date = DateFormat('HH:mm').format(mockDate(DateTime(2020)));

    return date;
  }
}
