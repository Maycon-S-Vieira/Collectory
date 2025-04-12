import 'package:collectory/controller/collectory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class IniView extends StatefulWidget {
  const IniView({super.key});

  @override
  State<IniView> createState() => _IniViewState();
}

class _IniViewState extends State<IniView> {
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
      appBar: AppBar(
        title: Text('Home'),
          actions: [
            IconButton(onPressed: (){
              ctrl.limpar_variaveis();
              Navigator.pushNamedAndRemoveUntil(context, 
              'login', (Route<dynamic>route) => false);
            }, 
            icon: Icon(Icons.exit_to_app_outlined)),
          ],
        ),
      body: Padding(
        padding: EdgeInsets.all(30),
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

            if(ctrl.verificaItens())
              ctrl.visualizarItens ? visualizarItens() : visualizarGrid(),
            
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

  Widget visualizarItens() {
    Map<String, int> mapaTitulos = {};

    for(var item in ctrl.itens){
      if(mapaTitulos.containsKey(item.titulo)){
        mapaTitulos[item.titulo] = mapaTitulos[item.titulo]! + 1;
      }else{
        mapaTitulos[item.titulo] = 1;
      }
    }

    List<MapEntry<String, int>> titulosUnicos = mapaTitulos.entries.toList();

    return Expanded(
      child: ListView.builder(
        itemCount: titulosUnicos.length,
        itemBuilder: (context, index) {
          final item = titulosUnicos[index];
          return SizedBox(
            child: Card(
              child: ListTile(
                title: Text(item.key),
                subtitle: Text('Volumes: ${item.value.toStringAsFixed(5)}\n'
                'Coleção Completa? '),
                onTap: (){
                  final itensSelecionados = ctrl.itens.where((e) => e.titulo == item.key).toList();
                  Navigator.pushNamed(context, 'visualizar', arguments: itensSelecionados); 
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget visualizarGrid() {

    Map<String, int> mapaTitulos = {};

    for(var item in ctrl.itens){
      if(mapaTitulos.containsKey(item.titulo)){
        mapaTitulos[item.titulo] = mapaTitulos[item.titulo]! + 1;
      }else{
        mapaTitulos[item.titulo] = 1;
      }
    }

    List<MapEntry<String, int>> titulosUnicos = mapaTitulos.entries.toList();

    return Expanded(
      child: GridView.builder(
        itemCount: titulosUnicos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final item = titulosUnicos[index];
          return SizedBox(
            child: Card(
              child: ListTile(
                title: Text(item.key),
                subtitle: Text('Volumes: ${item.value.toStringAsFixed(5)}\n'
                'Coleção Completa? '),
              ),
            ),
          );
        },
      ),
    );
  }
}


