
import 'package:flutter/material.dart';
import '../model/usuario_model.dart';
import '../model/item_model.dart';

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

  void Add_Usuarios(){
    _usuarios.add(Usuario(
      nome: Nome.text,
      email: Email.text,
      telefone: Telefone.text,
      senha: Senha.text
    ));
    limpar_variaveis();
    notifyListeners();
  }

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

  bool verificaUsuario(){
    return _usuarios.any((usuario) => usuario.email == Email.text && usuario.senha == Senha.text);
  }

  void gravaPerfilLogado(){
    EmailLogado = Email.text;
  }

  void perfilUsuario(){
    final usuario =  _usuarios.firstWhere((usuario) => usuario.email == EmailLogado);

    Nome.text = usuario.nome;
    Email.text = usuario.email;
    Telefone.text = usuario.telefone;
    Senha.text = usuario.senha;
  }

  String? recuperarSenhaPorEmail(String email) {
    try {
      final usuario = _usuarios.firstWhere((u) => u.email == email);
      return usuario.senha;
    } catch (e) {
      return null;
    }
  }
}