import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart'; 
import '../models/usuario.dart'; 

class CadastroUsuarioScreen extends StatefulWidget {
  @override
  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _usuarioController = UsuarioController();
  List<Usuario> _usuarios = [];
  Usuario? _usuarioParaEdicao;

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    _usuarios = await _usuarioController.getUsuarios();
    setState(() {});
  }

  Future<void> _salvarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final novoUsuario = Usuario(
        id: _usuarioParaEdicao?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nomeController.text,
        senha: _senhaController.text,
      );

      if (_usuarioParaEdicao != null) {
        await _usuarioController.atualizarUsuario(novoUsuario);
      } else {
        await _usuarioController.adicionarUsuario(novoUsuario);
      }

      _limparFormulario();
      _loadUsuarios();
    }
  }

  void _editarUsuario(Usuario usuario) {
    setState(() {
      _usuarioParaEdicao = usuario;
      _nomeController.text = usuario.nome;
      _senhaController.text = usuario.senha;
    });
  }

  Future<void> _removerUsuario(String id) async {
    await _usuarioController.removerUsuario(id);
    _loadUsuarios();
  }

  void _limparFormulario() {
    setState(() {
      _usuarioParaEdicao = null;
      _nomeController.clear();
      _senhaController.clear();
    });
  }

  String? _validarCampoObrigatorio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome*'),
                validator: _validarCampoObrigatorio,
              ),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha*'),
                validator: _validarCampoObrigatorio,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarUsuario,
                child: Text(_usuarioParaEdicao == null ? 'Salvar' : 'Atualizar'),
              ),
              if (_usuarioParaEdicao != null)
                TextButton(
                  onPressed: _limparFormulario,
                  child: Text('Cancelar Edição'),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = _usuarios[index];
                    return ListTile(
                      title: Text(usuario.nome),
                      subtitle: Text('ID: ${usuario.id}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editarUsuario(usuario),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removerUsuario(usuario.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}