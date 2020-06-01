import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/widgets/contacts_list_tile_widget.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var currentPage = 0;
  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5,),
        CupertinoSegmentedControl(
          onValueChanged: (val) {
            setState(() {
              print(val);
              currentPage = val;
            });
          },
          pressedColor: Colors.green.withOpacity(0.2),
          children: {
            0: Padding(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 50),
              child: Text(
                "Online",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            1: Padding(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 50),
              child: Text(
                "All",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          },
          selectedColor: Colors.green,
          unselectedColor: Colors.white12,
          borderColor: Colors.transparent,
          groupValue: currentPage,
        ),
        SizedBox(height: 10,),
        Expanded(
          child: Padding(
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
                itemBuilder: (BuildContext context, int index) {
                  if (index == 6 || index == 16) return Container();
                  return ContactsListTile(
                    image: "https://picsum.photos/id/${1001 + index}/200/200",
                    name: mockName(),
                    status: "Hey there I'm here",
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
    date = DateFormat('MMM dd, HH:mm').format(mockDate(DateTime(2020)));

    return date;
  }
}
