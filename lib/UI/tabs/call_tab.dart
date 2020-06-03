import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/widgets/call_list_tile_widget.dart';


//TODO Add Functionality and Users List from Database

class CallTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 0.5,
              color: Colors.white12,
            );
          },
          itemCount: 20,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index == 6 || index == 16) return Container();
            return CallListTile(
              image: "https://picsum.photos/id/${1001 + index}/200/200",
              name: mockName(),
              isCallIncoming: random.nextBool(),
              isCallMissed: random.nextBool(),
              isCallAudio: random.nextBool(),
              time: randomDate(),
            );
          },
        ),
      ),
    );
  }
  randomDate() {
    String date;
    date = DateFormat('MMM dd, HH:mm').format(mockDate(DateTime(2020)));

    return date;
  }
}
