import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/stories_screen.dart';
import 'package:nixmessenger/models/story_model.dart';
import 'package:nixmessenger/models/user_model.dart';
import '../../services/db_service.dart';

class StatusWidget extends StatefulWidget {

  @override
  _StatusWidgetState createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  final ScrollController scrollController = new ScrollController();

  double scrollLength = 0;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: PageStorageKey('StatusWidget'),
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
          ),
          Column(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    Center(
                      child: StreamBuilder<UserData>(
                        stream: DBService.instance.fetchUserData(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData)
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            backgroundImage: snapshot?.data?.profilePicture!=null? CachedNetworkImageProvider(snapshot?.data?.profilePicture):null,
                          );
                          return Container();
                        }
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:4.0),
                child: Text(
                  "Your Story",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  textScaleFactor: 0.8,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          SizedBox(
            width: 8,
          ),
          StreamBuilder<List<Stories>>(
              stream: DBService.instance.getAllStories(DBService.user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var storiesList = snapshot.data;
                  storiesList.retainWhere(
                      (element) => element?.file?.isNotEmpty ?? false);
                  storiesList
                      .retainWhere((element) => element?.file[0]?.time != null);
                  storiesList.sort((a, b) => a.file[0].time
                      .toDate()
                      .compareTo(b.file[0].time.toDate()));
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      key: PageStorageKey('stories'),
                      addAutomaticKeepAlives: true,
                      cacheExtent: 10000,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Stories data = snapshot.data[index];
                        if (data?.file == null || (data?.userImage == null))
                          return Container();
                        return SizedBox(
                          width: 75,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  scrollLength = (await Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    StoryScreen(
                                                      data: snapshot.data,
                                                      initialPage: index,
                                                    )),
                                          ) ??
                                          0) *
                                      39;

                                  scrollController.jumpTo(scrollLength);
                                },
                                child: Hero(
                                  tag: data.documentID,
                                  transitionOnUserGestures: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: CircleAvatar(
                                      radius: 31,
                                      backgroundColor: Colors.green,
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white24,
                                          radius: 25,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  data?.userImage ??
                                                      data?.file[0]?.source),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:4.0),
                                child: Text(
                                  data?.userName,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  textScaleFactor: 0.8,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container(
                  height: 70,
                );
              }),
        ],
      ),
    );
  }
}
