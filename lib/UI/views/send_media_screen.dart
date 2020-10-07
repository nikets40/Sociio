import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/models/user_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class SendMediaScreen extends StatefulWidget {
  final UserData userData;
  final File image;


  SendMediaScreen({this.userData, this.image});

  @override
  _SendMediaScreenState createState() => _SendMediaScreenState();
}

class _SendMediaScreenState extends State<SendMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            if (MediaQuery.of(context).viewInsets.bottom != 0)
              FocusScope.of(context).unfocus();
            else
              Navigator.pop(context);
          },
          color: Colors.green,
        ),
        titleSpacing: 0,
        title:Row(
          children: [
            CircleAvatar(
              backgroundImage:
              CachedNetworkImageProvider(widget.userData.profilePicture),
              radius: kToolbarHeight*0.35,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userData?.name ?? widget.userData.number,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Text(
                    widget.userData?.isOnline ?? false
                        ? "Online"
                        : timeago.format(widget.userData.lastSeen.toDate()),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        )
      ),
      body: PhotoView(imageProvider: FileImage(widget.image),minScale: 1.0,initialScale: 1.0,),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.green,child: Icon(Icons.send,color: Colors.white,),onPressed: (){Navigator.pop(context,true);},),
    );
  }
}
