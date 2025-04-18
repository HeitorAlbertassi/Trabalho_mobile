import '../models/cliente.dart'; // Sobe uma pasta (para fora de 'controllers') e entra em 'models'
import '../utils/file_manager.dart'; // Sobe uma pasta (para fora de 'controllers') e entra em 'utils'
import 'dart:convert';

class ClienteController {
  final FileManager _fileManager = FileManager('clientes.json');

  // Getter para a lista de clientes (carregamento preguiçoso)
  List<Cliente>? _clientesCache;
  Future<List<Cliente>> get clientes async {
    if (_clientesCache == null) {
      _clientesCache = await getClientesInterno();
    }
    return _clientesCache!;
  }

  Future<List<Cliente>> getClientesInterno() async {
    String jsonString = await _fileManager.readFile();
    if (jsonString.isEmpty) return [];

    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Cliente.fromJson(json)).toList();
  }

  Future<void> salvarClientes(List<Cliente> clientes) async {
    List<Map<String, dynamic>> jsonList =
        clientes.map((cliente) => cliente.toJson()).toList();
    await _fileManager.writeFile(json.encode(jsonList));
    // Limpar o cache após salvar
    _clientesCache = null;
  }

  Future<void> adicionarCliente(Cliente cliente) async {
    final listaClientes = await clientes;
    listaClientes.add(cliente);
    await salvarClientes(listaClientes);
  }

  Future<void> atualizarCliente(Cliente clienteAtualizado) async {
    final listaClientes = await clientes;
    final index = listaClientes.indexWhere((cliente) => cliente.id == clienteAtualizado.id);
    if (index != -1) {
      listaClientes[index] = clienteAtualizado;
      await salvarClientes(listaClientes);
    }
  }

  Future<void> removerCliente(String id) async {
    final listaClientes = await clientes;
    listaClientes.removeWhere((cliente) => cliente.id == id);
    await salvarClientes(listaClientes);
  }
}