import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';
import '../model/item_model.dart';

class Visualizar_Colecao_View extends StatefulWidget {
  const Visualizar_Colecao_View({super.key});

  @override
  State<Visualizar_Colecao_View> createState() => _Visualizar_Colecao_ViewState();
}

class _Visualizar_Colecao_ViewState extends State<Visualizar_Colecao_View> {
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {

    final itens = ModalRoute.of(context)!.settings.arguments as List<Itens>;

    return Scaffold(
      appBar: AppBar(title: Text('Visualizar Coleção')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: visualizarLista(itens),
      ),
    );
  }

  Widget visualizarLista(List<Itens> lista) {
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final colecao = lista[index];
        return Card(
          child: ListTile(
            title: Text(colecao.titulo),
            subtitle: Text(
              'Autor: ${colecao.autor}\n'
              'Editora: ${colecao.editora}\n'
              'Volume: ${colecao.volume}\n'
              'Preço: R\$ ${colecao.preco.toStringAsFixed(2)}\n'
              'Modelo: ${colecao.modelo}',
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'excluir_itens');
              },
              icon: Icon(Icons.delete_outline),
            ),
          ),
        );
      },
    );
  }

  Widget visualizarGrid(List<Itens> lista) {
    return GridView.builder(
      itemCount: lista.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        final colecao = lista[index];
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(colecao.titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Autor: ${colecao.autor}'),
                Text('Volume: ${colecao.volume}'),
                Text('R\$ ${colecao.preco.toStringAsFixed(2)}'),
                Text('Modelo: ${colecao.modelo}'),
              ],
            ),
          ),
        );
      },
    );
  }
}