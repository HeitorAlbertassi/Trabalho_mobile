import 'dart:convert';
import '../models/produto.dart';
import '../utils/file_manager.dart';

class ProdutoController {
  final FileManager _fileManager = FileManager('produtos.json');

  Future<List<Produto>> getProdutos() async {
    String jsonString = await _fileManager.readFile();
    if (jsonString.isEmpty) return [];

    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Produto.fromJson(json)).toList();
  }

  Future<void> salvarProdutos(List<Produto> produtos) async {
    List<Map<String, dynamic>> jsonList =
        produtos.map((produto) => produto.toJson()).toList();
    await _fileManager.writeFile(json.encode(jsonList));
  }

  Future<void> adicionarProduto(Produto produto) async {
    final produtos = await getProdutos();
    produtos.add(produto);
    await salvarProdutos(produtos);
  }

  Future<void> atualizarProduto(Produto produtoAtualizado) async {
    final produtos = await getProdutos();
    final index = produtos.indexWhere((produto) => produto.id == produtoAtualizado.id);
    if (index != -1) {
      produtos[index] = produtoAtualizado;
      await salvarProdutos(produtos);
    }
  }

  Future<void> removerProduto(String id) async {
    final produtos = await getProdutos();
    produtos.removeWhere((produto) => produto.id == id);
    await salvarProdutos(produtos);
  }
}