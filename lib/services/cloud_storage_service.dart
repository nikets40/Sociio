import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {

  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage _storage;
  StorageReference _baseRef;
  String profileImages = "profile_images";
  String images = "images";

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

   uploadUserImage(File _image) async {
     final User user =  FirebaseAuth.instance.currentUser;
    try {
        await _baseRef
            .child(profileImages)
            .child(user.uid)
            .putFile(_image)
            .onComplete;

        var imageUrl = await _baseRef.child(profileImages).child(user.uid).getDownloadURL();

//        print(imageUrl);
        return imageUrl.toString();
    }
    catch (e) {
      print(e);
      return null;
    }
  }

  uploadMedia(File _image)async{
    final User user =  FirebaseAuth.instance.currentUser;
    try {
      await _baseRef
          .child("messages")
          .child(images)
          .child(user.uid)
          .putFile(_image)
          .onComplete;

      var imageUrl = await _baseRef.child("messages").child(images).child(user.uid).getDownloadURL();

      return imageUrl.toString();
    }
    catch (e) {
      print(e);
      return null;
    }
  }
}