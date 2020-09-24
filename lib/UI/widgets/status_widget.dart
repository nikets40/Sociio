import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nixmessenger/UI/views/stories_screen.dart';
import 'package:nixmessenger/models/story_model.dart';
import '../../services/db_service.dart';

class StatusWidget extends StatelessWidget {
  final String userID;

  StatusWidget(this.userID);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 18,
          ),
          SizedBox(
            height: 60,
            width: 60,
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    backgroundImage: AssetImage("assets/images/user.jpeg"),
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
          StreamBuilder<List<Stories>>(
              stream: DBService.instance.getAllStories(userID),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return SizedBox(
                    height: 70,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Stories data = snapshot.data[index];
                          return Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (context, animation1, animation2) =>
                                          StoryScreen(data: snapshot.data,initialPage: index,)
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: data.documentID,
                                  child: Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),
                                    child: CircleAvatar(
                                      radius: 31,
                                      backgroundColor: Colors.green,
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.black,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white24,
                                          radius: 25,
                                          backgroundImage: CachedNetworkImageProvider(
                                              data?.userImage??data?.file[0]?.source),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data.length),
                  );
                return Container(
                  height: 70,
                );
              }),
        ],
      ),
    );
  }
}
