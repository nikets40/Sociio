import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';

class ChatsScreen extends StatefulWidget {
  final String image;
  final String name;

  ChatsScreen({
    this.image = "https://picsum.photos/id/${1001 + 1}/200/200",
    this.name= "Niket Singh"});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  TextEditingController textEditingController;
  bool isTextFieldExpanded = false;

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
              child: ChatsList(),
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
                  onPressed: textEditingController.text == "" ? null : () {},
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          Random random = new Random();
          bool myMessage = random.nextBool();
          return Align(
            alignment: myMessage
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: screenWidth(context) * 0.4,
                maxWidth: screenWidth(context) * 0.85,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: myMessage ? Colors.green : Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    messages[index],
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
