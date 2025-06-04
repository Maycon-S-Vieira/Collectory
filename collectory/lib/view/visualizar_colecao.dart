import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/itens_controller.dart';
import '../controller/usuario_controller.dart';
import '../model/item_model.dart';

class Visualizar_Colecao_View extends StatefulWidget {
  const Visualizar_Colecao_View({super.key});

  @override
  State<Visualizar_Colecao_View> createState() => _Visualizar_Colecao_ViewState();
}

class _Visualizar_Colecao_ViewState extends State<Visualizar_Colecao_View> {
  final itemCtrl = GetIt.I.get<ItemController>();
  final usuarioCtrl = GetIt.I.get<UsuarioController>();

  String? tituloColecao;
  List<Itens> itens = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    itemCtrl.addListener(() => setState(() {}));

    // Recebe título da coleção via argumentos da rota
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is List<Itens> && args.isNotEmpty) {
      itens = args;
      tituloColecao = itens[0].titulo;
      itemCtrl.buscarStatusColecaoCompleta(tituloColecao!);
    }
  }

  /*@override
  void initState() {
    super.initState();
    itemCtrl.addListener(() => setState(() {}));

    final itens = ModalRoute.of(context)!.settings.arguments as List<Itens>;
    if (itens.isNotEmpty) {
      final titulo = itens[0].titulo;
      itemCtrl.buscarStatusColecaoCompleta(titulo);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    if (tituloColecao == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Coleção')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final completa = itemCtrl.isColecaoCompleta(tituloColecao!);

    final itens = ModalRoute.of(context)!.settings.arguments as List<Itens>;

    final valorTotal = itens.fold<double>(0.0, (soma, item) => soma + item.preco);

    return Scaffold(
      appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$tituloColecao'),
          Text(
            'Total: R\$ ${valorTotal.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
    ),
      body: Column(
        children: [
          // Botão para alternar status coleção completa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                await itemCtrl.toggleColecaoCompleta(tituloColecao!);
              },
              child: Chip(
                label: Text(
                  completa ? 'Completa' : 'Incompleta',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: completa ? Colors.green : Colors.red,
              ),
            ),
          ),
          Expanded(
           child: visualizarLista(itens),
          ),
        ],
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'editar_item',
                      arguments: colecao,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Excluir Item'),
                        content: Text('Tem certeza que deseja excluir este volume?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Excluir'),
                          ),
                        ],
                      ),
                    );

                    if (confirm ?? false) {
                      final usuarioUid = usuarioCtrl.idUsuario();
                      await itemCtrl.excluirItem(usuarioUid.toString(), colecao.titulo, colecao.volume);
                    }
                  },
                ),
              ],
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