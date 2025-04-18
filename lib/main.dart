import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'controllers/usuario_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final usuarioController = UsuarioController();
  
  await usuarioController.carregarUsuariosIniciais(); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Cadastros',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), 
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
      },
    );
  }
}

class AppRoutes {
  static const home = '/home';
}