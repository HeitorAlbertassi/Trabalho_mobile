import 'package:flutter/material.dart';
import '../controllers/produto_controller.dart';
import '../models/produto.dart';

class CadastroProdutoScreen extends StatefulWidget {
  final Produto? produtoParaEdicao;

  CadastroProdutoScreen({this.produtoParaEdicao});

  @override
  _CadastroProdutoScreenState createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _qtdEstoqueController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _statusController = TextEditingController();
  final _custoController = TextEditingController();
  final _codigoBarraController = TextEditingController();
  final _produtoController = ProdutoController();

  @override
  void initState() {
    super.initState();
    if (widget.produtoParaEdicao != null) {
      _carregarDadosParaEdicao(widget.produtoParaEdicao!);
    }
    // Inicializa o valor padrão para o status
    _statusController.text = widget.produtoParaEdicao?.status.toString() ?? '0';
  }

  void _carregarDadosParaEdicao(Produto produto) {
    _nomeController.text = produto.nome;
    _unidadeController.text = produto.unidade;
    _qtdEstoqueController.text = produto.qtdEstoque.toString();
    _precoVendaController.text = produto.precoVenda.toStringAsFixed(2);
    _statusController.text = produto.status.toString();
    _custoController.text = produto.custo?.toStringAsFixed(2) ?? '';
    _codigoBarraController.text = produto.codigoBarra ?? '';
  }

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      final novoProduto = Produto(
        id: widget.produtoParaEdicao?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        unidade: _unidadeController.text,
        qtdEstoque: int.parse(_qtdEstoqueController.text),
        precoVenda: double.parse(_precoVendaController.text),
        status: int.parse(_statusController.text),
        custo: _custoController.text.isNotEmpty ? double.tryParse(_custoController.text) : null,
        codigoBarra: _codigoBarraController.text.isNotEmpty ? _codigoBarraController.text : null,
      );

      if (widget.produtoParaEdicao != null) {
        await _produtoController.atualizarProduto(novoProduto);
      } else {
        await _produtoController.adicionarProduto(novoProduto);
      }
      Navigator.pop(context); // Volta para a tela de listagem
    }
  }

  String? _validarCampoObrigatorio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  String? _validarNumero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    if (double.tryParse(value) == null) {
      return 'Informe um número válido.';
    }
    return null;
  }

  String? _validarInteiro(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    if (int.tryParse(value) == null) {
      return 'Informe um número inteiro válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produtoParaEdicao == null ? 'Cadastro de Produto' : 'Editar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome*'),
                validator: _validarCampoObrigatorio,
              ),
              TextFormField(
                controller: _unidadeController,
                decoration: InputDecoration(labelText: 'Unidade*'),
                validator: _validarCampoObrigatorio,
              ),
              TextFormField(
                controller: _qtdEstoqueController,
                decoration: InputDecoration(labelText: 'Quantidade em Estoque*'),
                keyboardType: TextInputType.number,
                validator: _validarInteiro,
              ),
              TextFormField(
                controller: _precoVendaController,
                decoration: InputDecoration(labelText: 'Preço de Venda*'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: _validarNumero,
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status (0 - Inativo, 1 - Ativo)*'),
                keyboardType: TextInputType.number,
                validator: _validarInteiro,
              ),
              TextFormField(
                controller: _custoController,
                decoration: InputDecoration(labelText: 'Custo'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _codigoBarraController,
                decoration: InputDecoration(labelText: 'Código de Barras'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarProduto,
                child: Text(widget.produtoParaEdicao == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CadastroProdutoListScreen extends StatefulWidget {
  @override
  _CadastroProdutoListScreenState createState() => _CadastroProdutoListScreenState();
}

class _CadastroProdutoListScreenState extends State<CadastroProdutoListScreen> {
  final _produtoController = ProdutoController();
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    _produtos = await _produtoController.getProdutos();
    setState(() {});
  }

  Future<void> _removerProduto(String id) async {
    await _produtoController.removerProduto(id);
    _loadProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Produtos')),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return ListTile(
            title: Text(produto.nome),
            subtitle: Text('Unidade: ${produto.unidade}, Preço: ${produto.precoVenda.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroProdutoScreen(produtoParaEdicao: produto),
                      ),
                    ).then((_) => _loadProdutos()); // Recarrega ao voltar
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removerProduto(produto.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CadastroProdutoScreen()),
          ).then((_) => _loadProdutos()); // Recarrega ao voltar
        },
        child: Icon(Icons.add),
      ),
    );
  }
}