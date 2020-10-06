import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/widgets/chats_list_tile_widget.dart';
import 'package:nixmessenger/UI/widgets/status_widget.dart';

import '../widgets/status_widget.dart';

class ChatsDemoTab extends StatefulWidget {
  @override
  _ChatsDemoTabState createState() => _ChatsDemoTabState();
}

class _ChatsDemoTabState extends State<ChatsDemoTab> {
  Random random = Random();

  String user;
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
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 100.0, top: 0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) =>
        ChatsListTile(
          isOnline: random.nextBool(),
          name: mockName(),
          image: images[index],
          dateTimeLastMessage:
          timeago.format(lastMessageTime[index],locale: 'en_short').replaceAll("~", "")+ " ago",
          lastMessage: lastMessages[index],
          unReadMessages: 0,
          isChatMuted: random.nextBool(),
        )
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

  List<String> images = [
    "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80",
    "https://images.unsplash.com/photo-1496345875659-11f7dd282d1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
    "https://images.unsplash.com/photo-1493391809144-7ac16187f221?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=700&q=80",
    "https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
    "https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80",
  ];

  List<String> lastMessages = [
    "Sure, no Problem!",
    "Thanks Man, really appreciate it",
    "Ok! bye buddy",
    "Wow! Really, thats awesome",
    "No Problem Mate",
    "So you coming to the party or not"
  ];

  List<DateTime> lastMessageTime = [
    DateTime.now().subtract(Duration(minutes: 10)),
    DateTime.now().subtract(Duration(hours: 1,minutes: 50)),
    DateTime.now().subtract(Duration(hours: 6)),
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().subtract(Duration(days: 4)),
  ];

}
