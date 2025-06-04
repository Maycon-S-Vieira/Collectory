import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/itens_controller.dart';

class InformacoesView extends StatefulWidget {
  const InformacoesView({super.key});

  @override
  State<InformacoesView> createState() => _InformacoesViewState();
}

class _InformacoesViewState extends State<InformacoesView> {
  final ctrl = GetIt.I.get<ItemController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações')),
      
    );
  }
}