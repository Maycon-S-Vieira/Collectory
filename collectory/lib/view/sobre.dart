import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  final ctrl = GetIt.I.get<CollectoryController>();

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
              'Criado e desenvolvido por Maycon Silva Vieira',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}