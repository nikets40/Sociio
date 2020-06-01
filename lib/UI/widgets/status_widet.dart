import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 18,),
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
          SizedBox(
            height: 70,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 7 || index == 17) return Container();
                  return Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        radius: 31,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 25,
                            backgroundImage: NetworkImage(
                                "https://picsum.photos/id/${1000 + index}/600/400"),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: 7),
          ),
        ],
      ),
    );
  }
}
