import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/views/chats_screen_view.dart';
import 'package:nixmessenger/UI/widgets/chats_list_tile_widget.dart';
import 'package:nixmessenger/UI/widgets/status_widet.dart';
import 'package:nixmessenger/models/conversation.dart';
import 'package:nixmessenger/services/db_service.dart';

class ChatsTab extends StatefulWidget {
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {

  Random random = Random();

  Future<String>user()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child:
                FutureBuilder(future: user(),builder: (context, snapshot) => chatsList(snapshot.data),)
            ),
          ),
        ),
      ],
    );
  }

  chatsList(user){
    return
      StreamBuilder <List<ConversationSnippet>>(
          stream: DBService.instance.getUserConversations(user),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text("loading");
            }
            var chats = snapshot.data;

            return ListView.builder(
              padding: EdgeInsets.only(bottom:100.0,top: 0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatsScreen(
                                conversationID: chats[index].conversationID,
//                                isOnline: true,
                                name: chats[index].name,
                                image:chats[index].profilePicture ,
                                myID: user
                            )));
                    DBService.instance.resetUnseenCount(chats[index].id);
                  },
                  child: ChatsListTile(
                    name: chats[index].name,
                    image: chats[index].profilePicture,
                    // dateTimeLastMessage: getFormattedDate(chats[index].timestamp),
                    dateTimeLastMessage: timeago.format(chats[index].timestamp.toDate()),
                    lastMessage: chats[index].lastMessage,
                    unReadMessages: chats[index].unseenCount,
                    isChatMuted: random.nextBool(),
                  ),
                );
              },
            );
          }
      );
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
