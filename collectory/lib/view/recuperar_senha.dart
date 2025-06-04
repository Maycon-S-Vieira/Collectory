import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/usuario_controller.dart';

class RecuperarView extends StatefulWidget {
  const RecuperarView({super.key});

  @override
  State<RecuperarView> createState() => _RecuperarViewState();
}

class _RecuperarViewState extends State<RecuperarView> {
  final ctrl = GetIt.I.get<UsuarioController>();

  @override
  void initState() {
    super.initState();
    ctrl.EmailEsqueceuSenha.clear();;
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: ctrl.EmailEsqueceuSenha,
              decoration: const InputDecoration(
                labelText: 'Digite seu e-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ctrl.esqueceuSenha(context); // chama a função corretamente
              },
              child: const Text('Enviar E-mail de Recuperação'),
            ),
          ],
        ),
      ),
    );
  }
}