
import 'package:flutter/material.dart';
import '../model/usuario_model.dart';
import '../model/item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectoryController extends ChangeNotifier{
  final Nome = TextEditingController();
  final Email = TextEditingController();
  final Telefone = TextEditingController();
  final Senha = TextEditingController();
  final SenhaConfirma = TextEditingController();
  final Titulo = TextEditingController();
  final Autor = TextEditingController();
  final Editora = TextEditingController();
  final Volume = TextEditingController();
  final Preco = TextEditingController();
  final Modelo = TextEditingController();
  final double totalColecao = 0;
  String EmailLogado = '';

  final List<Usuario> _usuarios = [];
  final List<Itens> _itens = [];

  void Add_Usuarios() async {
    try {
      // 1. Cria o usuário com email e senha no Firebase Auth
      UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email.text.trim(),
        password: Senha.text.trim(),
      );

      // 2. Salva os dados adicionais no Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(userCred.user!.uid).set({
        'nome': Nome.text,
        'email': Email.text,
        'telefone': Telefone.text,
        'criado_em': DateTime.now(),
        //'foto_url': '',
      });

      EmailLogado = Email.text;
      limpar_variaveis();
      notifyListeners();
    } catch (e) {
      print('Erro ao criar usuário: $e');
    }
  }

  String? idUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
  /*void Add_Usuarios(){
    _usuarios.add(Usuario(
      nome: Nome.text,
      email: Email.text,
      telefone: Telefone.text,
      senha: Senha.text
    ));
    limpar_variaveis();
    notifyListeners();
  }*/

  bool Add_Itens(){
    int? volumeInt = int.tryParse(Volume.text);
    double? precoDoub = double.tryParse(Preco.text);

    if (volumeInt == null || precoDoub == null) {
      return false;
    }

    _itens.add(Itens(
      titulo: Titulo.text,
      autor: Autor.text,
      editora: Editora.text,
      volume: volumeInt,
      preco: precoDoub,
      modelo: Modelo.text
    ));
    limpar_pag_itens();
    notifyListeners();
    return true;
  }

  final bool _visualizarItens = true;

  List<Itens> get itens => _itens;
  bool get visualizarItens => _visualizarItens;

  bool verificaItens(){
    return _itens.isNotEmpty;
  }

  void limpar_pag_itens(){
    Titulo.clear();
    Autor.clear();
    Editora.clear();
    Volume.clear();
    Preco.clear();
    Modelo.clear();
  }

  void limpar_variaveis(){
    Nome.clear();
    Email.clear();
    Telefone.clear();
    Senha.clear();
    SenhaConfirma.clear();
  }

  /*bool verificaUsuario(){
    return _usuarios.any((usuario) => usuario.email == Email.text && usuario.senha == Senha.text);
  }*/

  Future<bool> verificaUsuario() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email.text.trim(),
        password: Senha.text.trim(),
      );
      EmailLogado = Email.text;
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  void gravaPerfilLogado(){
    EmailLogado = Email.text;
  }

  Future<void> perfilUsuario() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        Nome.text = data['nome'] ?? '';
        Email.text = data['email'] ?? '';
        Telefone.text = data['telefone'] ?? '';
        // Senha não é recuperável — deixe em branco ou esconda
      }
    }
  } catch (e) {
    print('Erro ao carregar perfil: $e');
  }
}

  /*void perfilUsuario(){
    final usuario =  _usuarios.firstWhere((usuario) => usuario.email == EmailLogado);

    Nome.text = usuario.nome;
    Email.text = usuario.email;
    Telefone.text = usuario.telefone;
    Senha.text = usuario.senha;
  }*/

  String? recuperarSenhaPorEmail(String email) {
    try {
      final usuario = _usuarios.firstWhere((u) => u.email == email);
      return usuario.senha;
    } catch (e) {
      return null;
    }
  }
}