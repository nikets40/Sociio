import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nixmessenger/UI/views/Image_fullscreen_view.dart';
import 'package:nixmessenger/models/conversation.dart';
import 'package:nixmessenger/services/cloud_storage_service.dart';
import 'package:nixmessenger/services/media_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/models/user_model.dart';
import 'package:nixmessenger/services/db_service.dart';

class ChatsScreen extends StatefulWidget {
  final String conversationID;
  final String myID;
  final otherUserID;

  ChatsScreen({
    this.conversationID,
    this.otherUserID,
    this.myID,
  });

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController textEditingController;
  bool isTextFieldExpanded = false;
  ScrollController _scrollController = new ScrollController();
  String userUID;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
    userUID = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var iconColor = Colors.green;
    return Scaffold(
      key: PageStorageKey('Chats Screen'),
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
        title: StreamBuilder<UserData>(
            stream:
                DBService.instance.fetchUserData(userUid: widget.otherUserID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData otherUser = snapshot.data;
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(otherUser.profilePicture),
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
                            otherUser?.name ?? otherUser.number,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            otherUser?.isOnline ?? false
                                ? "Online"
                                : timeago.format(otherUser.lastSeen.toDate()),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container();
            }),
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
              child: StreamBuilder<Conversation>(
                  stream: DBService.instance.fetchChat(widget.conversationID),
                  builder: (context, snapshot) {
                    print(widget.conversationID);
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      Timer(
                          Duration(milliseconds: 50),
                          () => {
                                _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent)
                              });
                      Conversation conversation = snapshot.data;

                      print("owner ID is ${conversation?.ownerID}");
                      DBService.instance.resetUnseenCount(
                          documentID: widget.conversationID,
                          userUID: userUID);

                      return ChatsList(
                        myID: widget.myID,
                        conversation: conversation,
                        scrollController: _scrollController,
                      );
                    } else
                      return Container();
                  }),
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
                          onPressed: () async {
                            PickedFile image = await MediaService.instance
                                .getImageFromLibrary();
                            String imageURL = await CloudStorageService.instance
                                .uploadMedia(File(image.path));
                            showUploadingMedia();
                            await DBService.instance.sendMessage(
                                message: imageURL,
                                conversationID: widget.conversationID,
                                recipientID: widget.otherUserID,
                                type: "image",
                                senderID: userUID
                            );

                          },
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
                  onPressed: textEditingController.text == ""
                      ? null
                      : () {
                          DBService.instance.sendMessage(
                             message: textEditingController.text,
                              conversationID:widget.conversationID,
                              recipientID: widget.otherUserID,
                              type: "text",
                              senderID: userUID
                          );
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

  @override
  bool get wantKeepAlive => true;

  void showUploadingMedia() {

  }
}

class ChatsList extends StatefulWidget {
  final ScrollController scrollController;
  final Conversation conversation;
  final String myID;

  ChatsList(
      {@required this.scrollController,
      @required this.conversation,
      @required this.myID});

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  bool uploadingImage = false;

  @override
  Widget build(BuildContext context) {
    bool showingDate = true;
    File image;
    return ListView.builder(
        cacheExtent: 100000,
        itemCount: widget.conversation?.messages?.length ?? 0,
        controller: widget.scrollController,
        itemBuilder: (context, index) {
          bool myMessage =
              widget.conversation?.messages[index].senderID == widget.myID;
          bool isPreviousMessageMine = false;
          if (index > 0)
            isPreviousMessageMine =
                widget.conversation?.messages[index - 1]?.senderID ==
                    widget.conversation?.messages[index]?.senderID;
          if (index > 0 &&
              widget.conversation.messages[index].time
                      .toDate()
                      .difference(widget.conversation?.messages[index - 1]?.time
                          ?.toDate())
                      .inMinutes >
                  5)
            showingDate = true;
          else
            showingDate = false;

          return Column(
            children: [
              if (index == 0)
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 35),
                  child: Text(
                    formattedDate(widget.conversation.messages[index].time),
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                ),
              if (showingDate)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Text(
                    formattedDate(widget.conversation.messages[index].time),
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                ),
              Align(
                alignment: myMessage
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // minWidth: screenWidth(context) * 0.1,
                    maxWidth: screenWidth(context) * 0.85,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8,
                        top: (isPreviousMessageMine && !showingDate) ? 1 : 15),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: myMessage ? Colors.green : Colors.white24,
                          borderRadius: myMessage
                              ? radiusMyMessages(index)
                              : radiusOtherMessages(index)),
                      child: IntrinsicWidth(
                        child: (widget.conversation.messages[index].type ==
                                "image")
                            ? imageBubble(
                                widget.conversation.messages[index].message)
                            : Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  widget.conversation?.messages[index]?.message,
                                  style: TextStyle(
                                      color: myMessage
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (index == widget.conversation.messages.length - 1 &&
                  uploadingImage)
                showUploadingImage(image)
            ],
          );
        });
  }

  formattedDate(Timestamp time) {
    // return DateFormat('EEEE, dd.MM.yy, hh:mm').format(time.toDate());
    return DateFormat('EEEE MMM dd yyyy, HH:mm').format(time.toDate());
  }

  BorderRadius radiusMyMessages(index) {
    double topLeft = 10, topRight = 10, bottomLeft = 10, bottomRight = 10;
    //NextMessage
    if (index < widget.conversation.messages.length - 1 &&
        widget.myID == widget.conversation.messages[index + 1].senderID)
      bottomRight = 0;
    //Previous Message
    if (index > 0 &&
        widget.myID == widget.conversation.messages[index - 1].senderID)
      topRight = 0;

    return BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomRight: Radius.circular(bottomRight),
        bottomLeft: Radius.circular(bottomLeft));
  }

  BorderRadius radiusOtherMessages(index) {
    double topLeft = 10, topRight = 10, bottomLeft = 10, bottomRight = 10;
    //NextMessage
    if (index < widget.conversation.messages.length - 1 &&
        widget.conversation.messages[index].senderID ==
            widget.conversation.messages[index + 1].senderID) bottomLeft = 0;
    //Previous Message
    if (index > 0 &&
        widget.conversation.messages[index].senderID ==
            widget.conversation.messages[index - 1].senderID) topLeft = 0;

    return BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomRight: Radius.circular(bottomRight),
        bottomLeft: Radius.circular(bottomLeft));
  }

  Widget imageBubble(imageURL) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 250),
                pageBuilder: (context, animation1, animation2) => ImageViewer(
                      images: [imageURL],
                    )));
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Hero(
                tag: imageURL,
                child: CachedNetworkImage(
                  imageUrl: imageURL,
                  fit: BoxFit.cover,
                )),
          )),
    );
  }

  Widget showUploadingImage(File image) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(
            image,
            fit: BoxFit.cover,
          ),
        ));
  }
}
