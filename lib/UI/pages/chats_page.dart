import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/widgets/chats_list_tile_widget.dart';
import 'package:nixmessenger/UI/widgets/status_widet.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String image = "assets/images/user.jpeg";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: ListView.builder(
                itemCount: 20,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if(index == 6 || index == 16){
                    return Container();
                  }
                  return ChatsListTile(
                    image: "https://picsum.photos/id/${1001+index}/200/200",
                    name: mockName(),
                    lastMessage: "Hey whatsup",
                    dateTimeLastMessage: randomDate(),
                    unReadMessages: mockInteger(0,3),
                    isChatMuted: false,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
  randomDate() {
    String date;
    Random random = Random();
    if(random.nextBool())
    date = DateFormat('dd MMM').format(mockDate(DateTime(2020)));
    else
    date = DateFormat('HH:mm').format(mockDate(DateTime(2020)));

    return date;
  }
}
