import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.perfilUsuario();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Nome:", style: TextStyle(fontWeight: FontWeight.bold)),
      Text(ctrl.Nome.text),
      SizedBox(height: 10),

      Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
      Text(ctrl.Email.text),
      SizedBox(height: 10),

      Text("Telefone:", style: TextStyle(fontWeight: FontWeight.bold)),
      Text(ctrl.Telefone.text),
      SizedBox(height: 10),
    ],
  ),
)
    );
  }
}