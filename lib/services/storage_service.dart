import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    try {
      String fileName = path.basename(file.path);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueFileName = '${timestamp}_$fileName';

      Reference ref = _storage.ref().child('tickets/$uniqueFileName');

      // Verificar tamaño del archivo (5MB máximo)
      int fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('El archivo excede el tamaño máximo permitido (5MB)');
      }

      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error al subir el archivo: $e');
    }
  }

  Future<List<String>> uploadMultipleFiles(List<File> files) async {
    List<String> urls = [];
    for (File file in files) {
      String url = await uploadFile(file);
      urls.add(url);
    }
    return urls;
  }
}