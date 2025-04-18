import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart'; 
import 'cadastro_usuario_screen.dart';
import 'home_screen.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  final UsuarioController _usuarioController = UsuarioController(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final usuario = await _usuarioController.verificarLogin(
                  _nomeController.text,
                  _senhaController.text,
                );
                if (usuario != null) {
                  // Navegar para a HomeScreen após o login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuário ou senha incorretos.')),
                  );
                }
              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroUsuarioScreen()),
                );
              },
              child: Text('Cadastrar Novo Usuário'),
            ),
          ],
        ),
      ),
    );
  }
}