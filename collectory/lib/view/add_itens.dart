import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../model/item_model.dart';

import '../controller/itens_controller.dart';

class Add_Itens_View extends StatefulWidget {
  const Add_Itens_View({super.key});

  @override
  State<Add_Itens_View> createState() => _Add_Itens_ViewState();
}

enum SingingCharacter { Manga, HQ, Livro }

class _Add_Itens_ViewState extends State<Add_Itens_View> {
  SingingCharacter? _character = SingingCharacter.Manga;
  final ctrl = GetIt.I.get<ItemController>();

  Itens? itemSelecionado;

  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Itens) {
      itemSelecionado = args;

      ctrl.Titulo.text = itemSelecionado!.titulo;
      ctrl.Autor.text = itemSelecionado!.autor;
      ctrl.Editora.text = itemSelecionado!.editora;
      ctrl.Volume.text = itemSelecionado!.volume.toString();
      ctrl.Preco.text = itemSelecionado!.preco.toString();
      ctrl.Modelo.text = itemSelecionado!.modelo;

      _character = SingingCharacter.values.firstWhere(
        (e) => e.name == itemSelecionado!.modelo,
        orElse: () => SingingCharacter.Manga,
      );
    } else {
      _character = SingingCharacter.Manga;
      ctrl.Modelo.text = _character!.name;
    }

    ctrl.addListener(() => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    ctrl.Modelo.text = _character!.name;
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = itemSelecionado != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdicao ? 'Editar Item' : 'Adicionar Item')),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: ctrl.Titulo,
              decoration: InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: ctrl.Autor,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: ctrl.Editora,
              decoration: InputDecoration(labelText: 'Editora'),
            ),
            TextField(
              controller: ctrl.Volume,
              decoration: InputDecoration(labelText: 'Volume'),
            ),
            TextField(
              controller: ctrl.Preco,
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            ListTile(
              title: const Text('Manga'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.Manga,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                    if(value != null){
                      ctrl.Modelo.text = value.name;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('HQ'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.HQ,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                    if(value != null){
                      ctrl.Modelo.text = value.name;
                    }
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Livro'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.Livro,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                    if(value != null){
                      ctrl.Modelo.text = value.name;
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(onPressed: () {
              if (isEdicao) {
                  ctrl.atualizarItem(itemSelecionado!);
                  Navigator.pop(context);
                } else {
                  ctrl.adicionarItem(context);
                }
              },
              child: Text(isEdicao ? 'Atualizar' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}