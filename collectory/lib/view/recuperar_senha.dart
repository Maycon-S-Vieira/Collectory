import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class RecuperarView extends StatefulWidget {
  const RecuperarView({super.key});

  @override
  State<RecuperarView> createState() => _RecuperarViewState();
}

class _RecuperarViewState extends State<RecuperarView> {
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.limpar_variaveis();
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
              controller: ctrl.Email,
              decoration: const InputDecoration(
                labelText: 'Digite seu e-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final senha = ctrl.recuperarSenhaPorEmail(ctrl.Email.text);
                if (senha != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Senha Recuperada'),
                      content: Text('Sua senha é: $senha'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Erro'),
                      content: const Text('E-mail não encontrado.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              },
              child: const Text('Recuperar Senha'),
            )
          ],
        ),
      ),
    );
  }
}