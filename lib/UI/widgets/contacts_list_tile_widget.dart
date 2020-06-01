import 'dart:math';

import 'package:flutter/material.dart';

class ContactsListTile extends StatelessWidget {
  final String name;
  final String status;
  final String image;

  ContactsListTile({
    @required this.name,
    @required this.status,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(image),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        status,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
