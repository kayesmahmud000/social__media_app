import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickHelper {
  final ImagePicker _picker = ImagePicker();

  Future<String?> picAndSaveImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Directory directory = await getApplicationDocumentsDirectory();

      final String fileName = basename(image.path);
      final String savedPath = '${directory.path}/$fileName';
      final File localImage = await File(image.path).copy(savedPath);

      return localImage.path;
    }
    return null;
  }
}
