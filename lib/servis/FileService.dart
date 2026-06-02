import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileService {
  /// Rasmni doimiy xotiraga saqlash
  static Future<String> saveImagePermanently(String imagePath) async {
    if (imagePath.isEmpty || imagePath.startsWith('assets/')) {
      return imagePath;
    }

    try {
      final File tempFile = File(imagePath);
      if (!await tempFile.exists()) return imagePath;

      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(imagePath);
      
      // Fayl nomini unikal qilish (vaqt belgisi bilan)
      final String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}_$fileName";
      final String permanentPath = p.join(directory.path, uniqueFileName);

      final File newFile = await tempFile.copy(permanentPath);
      return newFile.path;
    } catch (e) {
      print("Rasmni saqlashda xato: $e");
      return imagePath;
    }
  }

  /// Rasmni o'chirish (ixtiyoriy, bazadan o'chirilganda ishlatish mumkin)
  static Future<void> deleteImage(String imagePath) async {
    if (imagePath.isEmpty || imagePath.startsWith('assets/')) return;
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Rasmni o'chirishda xato: $e");
    }
  }
}
