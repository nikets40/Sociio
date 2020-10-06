
import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class MediaService{

  static MediaService instance = MediaService();
  final picker = ImagePicker();

  Future<PickedFile> getImageFromLibrary() async{
    try{
      return  await picker.getImage(source: ImageSource.gallery,maxHeight: 300);
    }
    catch(e){log("error in picking image:- $e");
    return null;
    }

  }
}