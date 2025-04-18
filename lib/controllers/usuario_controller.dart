import '../models/usuario.dart'; // Sobe uma pasta e entra em 'models'
import '../utils/file_manager.dart'; // Sobe uma pasta e entra em 'utils'
import 'dart:convert';

class UsuarioController {
  final FileManager _fileManager = FileManager('usuarios.json');

  Future<List<Usuario>> getUsuarios() async {
    String jsonString = await _fileManager.readFile();
    if (jsonString.isEmpty) return [];

    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Usuario.fromJson(json)).toList();
  }

  Future<void> salvarUsuarios(List<Usuario> usuarios) async {
    List<Map<String, dynamic>> jsonList =
        usuarios.map((usuario) => usuario.toJson()).toList();
    await _fileManager.writeFile(json.encode(jsonList));
  }
}