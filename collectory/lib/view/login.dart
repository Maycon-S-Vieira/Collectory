import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/usuario_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usuarioCtrl = GetIt.I.get<UsuarioController>();
  String? erroMessage;

  @override
  void initState() {
    super.initState();
  usuarioCtrl.addListener(() => setState(() {}));
  }

  void login() async{
    final sucesso = await usuarioCtrl.login(context);
    if(sucesso){
      Navigator.pushNamed(context, 'iniciar');
    }else{
      setState(() {
        erroMessage = 'Email ou senha incorretos!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
            'assets/images/logo.png',
            height: 200,
          ),
          SizedBox(height: 40),
            TextField(
              controller: usuarioCtrl.Email,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: usuarioCtrl.Senha,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            if(erroMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  erroMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            SizedBox(height: 40),
            LoginButtons(onLogin: login),
          ],
        ),
      ),
    );
  }
}

class LoginButtons extends StatelessWidget {
  final VoidCallback onLogin;
  final usuarioCtrl = GetIt.I.get<UsuarioController>();

  LoginButtons({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onLogin, 
          style: ElevatedButton.styleFrom(
            elevation: 4,
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 40,
              color: const Color.fromARGB(255, 2, 134, 196),
              fontWeight: FontWeight.bold,
            ),
          ),   
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'esqueceu');
          },
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            'Esqueceu sua senha?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            usuarioCtrl.limparCampos();
            Navigator.pushNamed(context, 'cadastro');
          },
          style: TextButton.styleFrom(
            overlayColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Text(
            'Cadastre-se',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue
            ),
          ),
        ),
      ],
    );
  }
}