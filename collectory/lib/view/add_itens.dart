import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class Add_Itens_View extends StatefulWidget {
  const Add_Itens_View({super.key});

  @override
  State<Add_Itens_View> createState() => _Add_Itens_ViewState();
}

enum SingingCharacter { Manga, HQ, Livro }

class _Add_Itens_ViewState extends State<Add_Itens_View> {
  SingingCharacter? _character = SingingCharacter.Manga;
  final ctrl = GetIt.I.get<CollectoryController>();

  @override
  void initState() {
    super.initState();
    ctrl.Modelo.text = _character!.name;
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Adicionar Itens')),
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
              final sucesso = ctrl.Add_Itens();
              if(!sucesso){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Erro: Volume ou Preço inválido."),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }else{
                Navigator.pop(context);
              }
            }, child: Text('Cadastrar')),
          ],
        ),
      ),
    );
  }
}