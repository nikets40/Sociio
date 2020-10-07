import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nixmessenger/UI/Shared/styles.dart';
import 'package:nixmessenger/UI/widgets/busy_overlay_widget.dart';
import 'package:nixmessenger/services/cloud_storage_service.dart';
import 'package:nixmessenger/services/db_service.dart';
import 'package:nixmessenger/services/media_service.dart';
import 'package:nixmessenger/services/navigation_service.dart';

class ProfileInfoView extends StatefulWidget {
  @override
  createState() => _ProfileInfoViewState();
}

class _ProfileInfoViewState extends State<ProfileInfoView> {
  final TextEditingController _controller = new TextEditingController();
  File image;
  var showLoading = false;
  String userUID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userUID = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return BusyOverlay(
      show: showLoading,
      title: "Please Wait\nCreating Profile",
      child: Scaffold(
        backgroundColor: Colors.white12,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Colors.green,
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: screenWidth(context),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Info",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Please Provide your name and optional profile photo",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey[350],
                      child: InkWell(
                        radius:screenWidth(context) / 6,
                        splashColor: Colors.black26,
                        onTap: () async {
                          try{
                            image = await MediaService.instance.getImageFromLibrary(ImageSource.gallery).then((value) => File(value.path));
                            if(image!=null)
                              setState(() {});
                          }catch(e){print(e);}

                        },
                        child: CircleAvatar(
                            radius: screenWidth(context) / 6,
                            backgroundColor: Colors.transparent,
                            child: image == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 60,
                                    color: Colors.grey[500],
                                  )
                                : null,
                            backgroundImage:
                                image != null ? FileImage(image) : null),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type your name here",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: screenWidth(context),
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text(
                      "Next",
                      textScaleFactor: 1.3,
                    ),
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });
                      var imageURl = (await CloudStorageService.instance
                          .uploadUserImage(image));
                      await DBService.instance
                          .addProfileInfoInDB(name:_controller.text, profilePicture:imageURl,userUid: userUID);
                      NavigationService.instance.navigateToWithClearTop("home");
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
