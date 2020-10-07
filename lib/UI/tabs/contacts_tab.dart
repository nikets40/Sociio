import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';
import 'package:nixmessenger/UI/views/chats_screen_view.dart';
import 'package:nixmessenger/UI/widgets/contacts_list_tile_widget.dart';
import 'package:nixmessenger/models/user_model.dart';
import 'package:nixmessenger/services/db_service.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  var currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5,),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl(
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
              child: StreamBuilder<List<UserData>>(
                stream: DBService.instance.fetchAllUsers(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    snapshot.data.removeWhere((element) => element.userID== FirebaseAuth.instance.currentUser.uid);
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        if(currentPage == 0 && !(snapshot.data[index]?.isOnline??false)){
                          return Container();
                        }
                        return Container(
                          height: 0.5,
                          color: Colors.white12,
                        );
                      },
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {

                        UserData data = snapshot.data[index];
                        print("is userOnline ${data?.isOnline}");
                        if(currentPage == 0 && !(data?.isOnline??false)){
                          return Container();
                        }
                        return GestureDetector(
                          onTap:(){
                            DBService.instance.createOrGetConversation(userUID: FirebaseAuth.instance.currentUser.uid,recipientID:data.userID, onSuccess:(_conversationID)async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatsScreen(otherUserID: data.userID,conversationID: _conversationID,myID: FirebaseAuth.instance.currentUser.uid,)));
                            });
                          },
                          child: ContactsListTile(
                            image:data.profilePicture ,
                            isOnline: data.isOnline,
                            name: data?.name?? data.number,
                            status: data?.status??"Hey there I'm here",
                          ),
                        );
                      },
                    );
                  }

                  return Container();
                }
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
