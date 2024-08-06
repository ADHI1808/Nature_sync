import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  Future<Uint8List?> pickImage(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile == null) return null; // Will return in an error

    List<int> imageBytes = await pickedFile.readAsBytes();
    Uint8List imageUint8List = Uint8List.fromList(imageBytes);

    return imageUint8List;
  }
}
