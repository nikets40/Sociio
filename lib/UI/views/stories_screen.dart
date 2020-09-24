import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:nixmessenger/models/story_model.dart';
import 'package:nixmessenger/utils/screen_util.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryScreen extends StatefulWidget {
  final List<Stories> data;
  final int initialPage;

  StoryScreen({@required this.data, this.initialPage});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  double opacity;
  double storyPosition;
  Size screenSize;
  GlobalKey containerKey = GlobalKey();
  int currentImageIndex = 0;
  PageController _pageController;
  int currentPage;

  @override
  void initState() {
    super.initState();
    opacity = 1;
    storyPosition = 0;
    _pageController =
        new PageController(initialPage: widget.initialPage, keepPage: true);
    currentPage = widget.initialPage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    if (containerKey.currentContext != null) position();
    return Container(
      color: Colors.black.withOpacity(opacity),
      child: Listener(
        onPointerMove: (_) {
          position();
        },
        onPointerUp: (_) {
          setState(() {
            opacity = 0;
          });

          Future.delayed(Duration(milliseconds: 100)).then((value) {
            position();
          });
        },
        child: Dismissible(
          key: const Key('key'),
          onDismissed: (dir) {
            opacity = 0;

            print("dismissed");
            Navigator.pop(context);
          },
          direction: DismissDirection.down,
          child: Hero(
            tag: widget.data[widget.initialPage].documentID,
            child: Container(
                key: containerKey,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    currentPage = index;
                  },
                  children: storyList(),
                )

                // initialPage: widget.initialPage, children: storyList()),
                ),
          ),
        ),
      ),
    );
  }

  List<Widget> storyList() {
    List<Widget> stories = new List<Widget>();
    for (int i = 0; i < widget.data.length; i++) {
      var story = widget.data[i].file;
      stories.add(GestureDetector(
        onTapUp: (_) {
          print("length of story");
          print(widget.data[widget.initialPage].file.length);

          if (_.globalPosition.dx >
              (screenSize.width /
                  2)) if (currentImageIndex <
              widget.data[widget.initialPage].file.length - 1)
            setState(() {
              currentImageIndex++;
            });
        },
        child: Story(
          onFlashForward: () async {
            if (i < widget.data.length - 1)
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            // else
            //   Navigator.pop(context);
          },
          onFlashBack: () async {
            if (i > 0)
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            else
              Navigator.pop(context);
          },
          momentCount: story.length,
          fullscreen: false,
          momentDurationGetter: (idx) => Duration(seconds: 5),
          momentBuilder: (ctx, idx) {
            return Material(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    story[idx].source),
                                fit: BoxFit.fitWidth)),
                      ),
                    ),
                  ),

                  Container(
                    // height: screenSize.height,
                    // width: screenSize.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6)
                    ], begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                          stops: [0,0.14,0.9,1]
                        )),
                  ),

                  ///Todo Complete the Story Heading
                  Positioned(
                    top: ScreenUtil.instance.setHeight(50),
                    left: ScreenUtil.instance.setWidth(11),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: ScreenUtil.instance.setWidth(20),
                            backgroundImage: CachedNetworkImageProvider(
                                widget.data[currentPage].userImage),
                          ),
                          SizedBox(
                            width: ScreenUtil.instance.setWidth(8),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil.instance.setHeight(2)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data[currentPage].userName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil.instance.setSp(15)),
                                ),
                                Text(
                                  getTime(story[idx].time),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: ScreenUtil.instance.setSp(13)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ));
    }

    return stories;
  }

  getTime(Timestamp time) {
    String timeAgo = timeago.format(time.toDate(), locale: 'en_short');
    return timeAgo.replaceAll('~', '');
  }

  position() {
    if (containerKey.currentContext != null) {
      RenderBox box = containerKey.currentContext.findRenderObject();
      Offset position =
          box.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;
      print("position on y axis $y"); //this is y - I think it's what you want
      opacity = y / MediaQuery.of(context).size.height;
      print(opacity);
      setState(() {
        opacity = 1 - opacity;
      });
    }
  }
}
