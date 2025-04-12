import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class FiltrosView extends StatefulWidget {
  const FiltrosView({super.key});

  @override
  State<FiltrosView> createState() => _FiltrosViewState();
}

class _FiltrosViewState extends State<FiltrosView> {
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtros')),
      
    );
  }
}