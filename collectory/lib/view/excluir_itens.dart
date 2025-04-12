import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class ExcluirView extends StatefulWidget {
  const ExcluirView({super.key});

  @override
  State<ExcluirView> createState() => _ExcluirViewState();
}

class _ExcluirViewState extends State<ExcluirView> {
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Excluir Itens')),
      
    );
  }
}