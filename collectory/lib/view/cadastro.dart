import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controller/collectory_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final ctrl = GetIt.I.get<CollectoryController>();
  String? senhaErro;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  void validarSenhas(){
    setState((){
      if(ctrl.Senha.text != ctrl.SenhaConfirma.text){
        senhaErro = "As senhas precisam ser iguais!";
      }else{
        senhaErro = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: ctrl.Nome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: ctrl.Email,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: ctrl.Telefone,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextFormField(
              obscureText: true,
              controller: ctrl.Senha,
              decoration: InputDecoration(labelText: 'Senha'),
              onChanged: (_) => validarSenhas(),
            ),
            TextFormField(
              obscureText: true,
              controller: ctrl.SenhaConfirma,
              decoration: InputDecoration(labelText: 'Confirmar senha'),
              onChanged: (_) => validarSenhas(),
            ),
            if(senhaErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  senhaErro!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 40),
            ElevatedButton(onPressed: senhaErro == null? () {
              ctrl.Add_Usuarios();
              Navigator.pop(context);
            } : null, 
            child: Text('Cadastrar')),
          ],
        ),
      ),
    );
  }
}