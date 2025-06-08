import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/usuario_controller.dart';
import '../controller/itens_controller.dart';
import '../model/item_model.dart';

class IniView extends StatefulWidget {
  const IniView({super.key});

  @override
  State<IniView> createState() => _IniViewState();
}

class _IniViewState extends State<IniView> {
  final usuarioCtrl = GetIt.I.get<UsuarioController>();
  final itemCtrl = GetIt.I.get<ItemController>();

  final List<String> colecoes = ['Manga', 'HQ', 'Livro'];

  @override
  void initState() {
    super.initState();

    usuarioCtrl.limparCampos();
    usuarioCtrl.addListener(() => setState(() {}));

    itemCtrl.addListener(() => setState(() {}));
    itemCtrl.iniciarListenerItens();

    for (var c in colecoes) {
      itemCtrl.buscarStatusColecaoCompleta(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
          actions: [
            IconButton(onPressed: (){
              usuarioCtrl.limparCampos();
              Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
            }, 
            icon: Icon(Icons.exit_to_app_outlined)),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.account_box, size: 30),
                  onPressed: (){
                    Navigator.pushNamed(context, 'perfil');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.attach_money, size: 30),
                  onPressed: (){
                    Navigator.pushNamed(context, 'informacoes');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, size: 30),
                  onPressed: (){
                    Navigator.pushNamed(context, 'configuracoes');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list_alt, size: 30),
                  onPressed: (){
                    Navigator.pushNamed(context, 'filtros');
                  },
                ),
              ],
            ),

            if(itemCtrl.temItens)
              visualizarItens(itemCtrl.itens),
            
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, 'sobre');
                    }, child: Text('Sobre'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 30),
                      onPressed: (){
                        Navigator.pushNamed(context, 'add_itens');
                    },
                  ),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget visualizarItens(List<Itens> itens) {
    final mapaTitulos = <String, int>{};
    for (var item in itens) {
      mapaTitulos[item.titulo] = (mapaTitulos[item.titulo] ?? 0) + 1;
    }

    final titulosUnicos = mapaTitulos.entries.toList();

    return Expanded(
      child: ListView.builder(
        itemCount: titulosUnicos.length,
        itemBuilder: (context, index) {
          final item = titulosUnicos[index];
          final statusCompleto = itemCtrl.colecoesCompletas[item.key] ?? false;
          return Card(
            child: ListTile(
              title: Text(item.key),
              subtitle: Text(
                'Volumes: ${item.value}\n'
                'Coleção Completa? ${statusCompleto ? 'Sim' : 'Não'}'
              ),
              onTap: () {
                final itensSelecionados = itens.where((e) => e.titulo == item.key).toList();
                Navigator.pushNamed(context, 'visualizar', arguments: itensSelecionados);
              },
            ),
          );
        },
      ),
    );
  }

  Widget visualizarGrid(List<Itens> itens) {
    final mapaTitulos = <String, int>{};
    for (var item in itens) {
      mapaTitulos[item.titulo] = (mapaTitulos[item.titulo] ?? 0) + 1;
    }

    final titulosUnicos = mapaTitulos.entries.toList();

    return Expanded(
      child: GridView.builder(
        itemCount: titulosUnicos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final item = titulosUnicos[index];
          return Card(
            child: ListTile(
              title: Text(item.key),
              subtitle: Text('Volumes: ${item.value}\nColeção Completa?'),
            ),
          );
        },
      ),
    );
  }
}


