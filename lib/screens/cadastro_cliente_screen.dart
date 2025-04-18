import 'package:flutter/material.dart';
import '../controllers/cliente_controller.dart';
import '../models/cliente.dart';

class CadastroClienteScreen extends StatefulWidget {
  final Cliente? clienteParaEdicao;

  CadastroClienteScreen({this.clienteParaEdicao});

  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _clienteController = ClienteController();

  @override
  void initState() {
    super.initState();
    if (widget.clienteParaEdicao != null) {
      _carregarDadosParaEdicao(widget.clienteParaEdicao!);
    }
  }

  void _carregarDadosParaEdicao(Cliente cliente) {
    _nomeController.text = cliente.nome;
    _tipoController.text = cliente.tipo;
    _cpfCnpjController.text = cliente.cpfCnpj;
    _emailController.text = cliente.email ?? '';
    _telefoneController.text = cliente.telefone ?? '';
    _cepController.text = cliente.cep ?? '';
    _enderecoController.text = cliente.endereco ?? '';
    _bairroController.text = cliente.bairro ?? '';
    _cidadeController.text = cliente.cidade ?? '';
    _ufController.text = cliente.uf ?? '';
  }

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      final novoCliente = Cliente(
        id: widget.clienteParaEdicao?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        tipo: _tipoController.text,
        cpfCnpj: _cpfCnpjController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        telefone: _telefoneController.text.isNotEmpty ? _telefoneController.text : null,
        cep: _cepController.text.isNotEmpty ? _cepController.text : null,
        endereco: _enderecoController.text.isNotEmpty ? _enderecoController.text : null,
        bairro: _bairroController.text.isNotEmpty ? _bairroController.text : null,
        cidade: _cidadeController.text.isNotEmpty ? _cidadeController.text : null,
        uf: _ufController.text.isNotEmpty ? _ufController.text : null,
      );

      if (widget.clienteParaEdicao != null) {
        await _clienteController.atualizarCliente(novoCliente);
      } else {
        await _clienteController.adicionarCliente(novoCliente);
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

  String? _validarTipo(String? value) {
    if (value == null || value.isEmpty || (value.toUpperCase() != 'F' && value.toUpperCase() != 'J')) {
      return 'Informe F para Física ou J para Jurídica.';
    }
    return null;
  }

  String? _validarCpfCnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clienteParaEdicao == null ? 'Cadastro de Cliente' : 'Editar Cliente'),
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
                controller: _tipoController,
                decoration: InputDecoration(labelText: 'Tipo (F - Física / J - Jurídica)*'),
                validator: _validarTipo,
                textCapitalization: TextCapitalization.characters,
              ),
              TextFormField(
                controller: _cpfCnpjController,
                decoration: InputDecoration(labelText: 'CPF/CNPJ*'),
                validator: _validarCpfCnpj,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: 'Bairro'),
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextFormField(
                controller: _ufController,
                decoration: InputDecoration(labelText: 'UF'),
                maxLength: 2,
                textCapitalization: TextCapitalization.characters,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarCliente,
                child: Text(widget.clienteParaEdicao == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CadastroClienteListScreen extends StatefulWidget {
  @override
  _CadastroClienteListScreenState createState() => _CadastroClienteListScreenState();
}

class _CadastroClienteListScreenState extends State<CadastroClienteListScreen> {
  final _clienteController = ClienteController();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    _clientes = await _clienteController.getClientes();
    setState(() {});
  }

  Future<void> _removerCliente(String id) async {
    await _clienteController.removerCliente(id);
    _loadClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Clientes')),
      body: ListView.builder(
        itemCount: _clientes.length,
        itemBuilder: (context, index) {
          final cliente = _clientes[index];
          return ListTile(
            title: Text(cliente.nome),
            subtitle: Text('Tipo: ${cliente.tipo}, CPF/CNPJ: ${cliente.cpfCnpj}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroClienteScreen(clienteParaEdicao: cliente),
                      ),
                    ).then((_) => _loadClientes()); // Recarrega ao voltar
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removerCliente(cliente.id),
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
            MaterialPageRoute(builder: (context) => CadastroClienteScreen()),
          ).then((_) => _loadClientes()); // Recarrega ao voltar
        },
        child: Icon(Icons.add),
      ),
    );
  }
}