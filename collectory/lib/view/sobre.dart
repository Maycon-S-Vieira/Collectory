import 'package:collectory/controller/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  final ctrl = GetIt.I.get<UsuarioController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre')),
      body: Column(
        children: [
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Projeto criado como prototipo para TCC, com o objetivo de catalogar e gerenciar coleções'
              ' de usuarios e colecionadores de livros, mangás e HQs.\n\n'
              'Criado e desenvolvido por Maycon Silva Vieira.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 25, height: 1.5),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}