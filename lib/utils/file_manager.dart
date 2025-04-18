import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  final String fileName;

  FileManager(this.fileName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeFile(String json) async {
    final file = await _localFile;
    return file.writeAsString(json);
  }
}