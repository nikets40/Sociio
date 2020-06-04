import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/services/db_service.dart';

class ChatsScreen extends StatefulWidget {
  final String image;
  final String name;
  final String conversationID;
  final String myID;

  ChatsScreen({
    this.conversationID,
    this.myID,
    this.image = "https://picsum.photos/id/${1001 + 1}/200/200",
    this.name= "Niket Singh"});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController textEditingController;
  bool isTextFieldExpanded = false;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var iconColor = Colors.green;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (MediaQuery.of(context).viewInsets.bottom != 0)
              FocusScope.of(context).unfocus();
            else
              Navigator.pop(context);
          },
          color: iconColor,
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              radius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Text(
                    "last active 5 hours ago",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call,
              size: 30,
              color: iconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.videocam,
              size: 30,
              color: iconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              size: 30,
              color: iconColor,
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<DocumentSnapshot>(
                stream:  Firestore.instance
              .collection("Conversations")
              .document(widget.conversationID)
              .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    {
                      Timer(Duration(milliseconds: 50),()=>{
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
                      });
                      var document = snapshot.data;
                      return ChatsList(
                        myID: widget.myID,
                        document: document,
                        scrollController: _scrollController,
                      );
                    }
                  else return Container();
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Container(
                  child: Visibility(
                    visible: !isTextFieldExpanded,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: iconColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Transform.rotate(
                            angle: -pi / 4,
                            child: Icon(
                              Icons.attach_file,
                              size: 30,
                              color: iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isTextFieldExpanded,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isTextFieldExpanded = !isTextFieldExpanded;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 25,
                      color: iconColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 5),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: textEditingController,
                              maxLines: 50,
                              minLines: 1,
                              onChanged: (val) {
                                setState(() {
                                  if (val == "")
                                    isTextFieldExpanded = false;
                                  else
                                    isTextFieldExpanded = true;
                                });
                              },
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white54),
                              decoration: InputDecoration.collapsed(
                                  hintText: " Aa",
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                  )),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.insert_emoticon,
                              size: 30,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: textEditingController.text == "" ? null : (){
                    DBService.instance.sendMessage(
                        textEditingController.text, widget.conversationID);
                    setState(() {
                      textEditingController.text = "";
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ChatsList extends StatelessWidget {
  final ScrollController scrollController;
  final DocumentSnapshot document;
  final String myID;

  ChatsList({@required this.scrollController, @required this.document, @required this.myID});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: document["messages"].length,
        controller: scrollController,
        itemBuilder: (context, index) {
          bool myMessage = document["messages"][index]["senderID"] == myID;
          bool isPreviousMessageMine = false;
          if(index>0)
            isPreviousMessageMine =document["messages"][index-1]["senderID"] == document["messages"][index]["senderID"];
          return Align(
            alignment: myMessage
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenWidth(context) * 0.1,
                maxWidth: screenWidth(context) * 0.85,
              ),
              child: Padding(
                padding: EdgeInsets.only(left:8.0,right:8 ,top: isPreviousMessageMine?1:15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: myMessage ? Colors.green : Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    document["messages"][index]["message"],
                    style: TextStyle(
                        color: myMessage ? Colors.black : Colors.white),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
