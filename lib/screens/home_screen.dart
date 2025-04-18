import 'package:flutter/material.dart';
import 'cadastro_usuario_screen.dart';
import 'cadastro_cliente_screen.dart';
import 'cadastro_produto_screen.dart';
import 'cadastro_cliente_screen.dart'; 
import 'cadastro_produto_screen.dart'; 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroUsuarioScreen()),
                );
              },
              child: Text('Gerenciar Usuários'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroClienteListScreen()),
                );
              },
              child: Text('Gerenciar Clientes'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroProdutoListScreen()),
                );
              },
              child: Text('Gerenciar Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}