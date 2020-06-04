import 'package:image_picker/image_picker.dart';

class MediaService{

  static MediaService instance = MediaService();
  final picker = ImagePicker();

  Future getImageFromLibrary() async{
    return  await picker.getImage(source: ImageSource.gallery);
  }
}