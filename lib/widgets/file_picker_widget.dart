import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerWidget extends StatelessWidget {
  final Function(List<File>) onFilesPicked;

  const FilePickerWidget({super.key, required this.onFilesPicked});

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'txt'],
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        onFilesPicked(files);
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.attach_file),
      label: const Text('Adjuntar archivos'),
      onPressed: _pickFiles,
    );
  }
}