import 'package:flutter/material.dart';
import '../model/item_model.dart';
import '../controller/usuario_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class ItensComId {
  final String id;
  final Itens item;

  ItensComId({required this.id, required this.item});
}

class ItemController extends ChangeNotifier {
  final Titulo = TextEditingController();
  final Autor = TextEditingController();
  final Editora = TextEditingController();
  final Volume = TextEditingController();
  final Preco = TextEditingController();
  final Modelo = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final UsuarioController usuarioCtrl = GetIt.I.get<UsuarioController>();

  // Cache local para status da coleção
  Map<String, bool> colecoesCompletas = {};

  List<Itens> itens = [];

  //List<Itens> get itens => _itens;

  bool get temItens => itens.isNotEmpty;

  // Busca status coleção completa do Firestore para um título específico
  Future<bool> buscarStatusColecaoCompleta(String titulo) async {
    final uid = usuarioCtrl.idUsuario();
    if (uid == null) return false;

    final docId = '${uid}_$titulo';
    final doc = await db.collection('colecoes').doc(docId).get();

    if (doc.exists) {
      final data = doc.data();
      final completa = data?['completa'] ?? false;
      colecoesCompletas[titulo] = completa;
      notifyListeners();
      return completa;
    } else {
      // Não existe registro - considera false
      colecoesCompletas[titulo] = false;
      notifyListeners();
      return false;
    }
  }

  // Salva status coleção completa no Firestore
  Future<void> salvarStatusColecaoCompleta(String titulo, bool completa) async {
    final uid = usuarioCtrl.idUsuario();
    if (uid == null) return;

    final docId = '${uid}_$titulo';
    await db.collection('colecoes').doc(docId).set({
      'uid': uid,
      'titulo': titulo,
      'completa': completa,
    }, SetOptions(merge: true));

    colecoesCompletas[titulo] = completa;
    notifyListeners();
  }

  // Retorna se a coleção está marcada como completa (cache)
  bool isColecaoCompleta(String titulo) {
    return colecoesCompletas[titulo] ?? false;
  }

  // Alterna o status da coleção e salva no Firestore
  Future<void> toggleColecaoCompleta(String titulo) async {
    final atual = isColecaoCompleta(titulo);
    await salvarStatusColecaoCompleta(titulo, !atual);
  }

  adicionarItem(context) {

    int? volume = int.tryParse(Volume.text);
    double? preco = double.tryParse(Preco.text);

    if (volume == null || preco == null) {
      erro(context, 'Volume ou preço inválido');
      return;
    }

    final colec = Itens(
      '',
      usuarioCtrl.idUsuario() ?? '',
      Titulo.text,
      Autor.text,
      Editora.text,
      volume,
      preco,
      Modelo.text,
    );

    db.collection('itens')
      .add(colec.toJson())
      .then((s)=> sucesso(context,'Item adicionado com sucesso'))
      .catchError((e)=> erro(context,'Não foi possível realizar a operação'))
      .whenComplete((){
        limparCampos();
        Navigator.pop(context);
      });

  }

  Future<void> atualizarItem(Itens item) async {
    try {
      await FirebaseFirestore.instance
          .collection('itens')
          .doc(item.id)
          .update({
            'titulo': Titulo.text,
            'autor': Autor.text,
            'editora': Editora.text,
            'volume': int.tryParse(Volume.text) ?? 0,
            'preco': double.tryParse(Preco.text) ?? 0.0,
            'modelo': Modelo.text,
          });

      await listar(); // Atualiza a lista após editar
    } catch (e) {
      debugPrint('Erro ao atualizar item: $e');
    }
  }

  void iniciarListenerItens() {
    listar().listen((listaItensComId) {
      itens = listaItensComId.map((e) => e.item).toList();
      notifyListeners();
    });
  }

  Future<void> excluirItem(String uid, String titulo, int volume) async {
    try {
      final snap = await db
          .collection('itens')
          .where('uid', isEqualTo: uid)
          .where('titulo', isEqualTo: titulo)
          .where('volume', isEqualTo: volume)
          .get();

      for (var doc in snap.docs) {
        await doc.reference.delete();
      }

      await listar(); // Atualiza a lista
    } catch (e) {
      print('Erro ao excluir item: $e');
    }
  }
  
  Stream<List<ItensComId>> listar() {
    final uid = usuarioCtrl.idUsuario();
    if (uid == null) {
      return Stream.value([]); // Retorna stream com lista vazia se não estiver autenticado
    }

    return db
        .collection('itens')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final item = Itens.fromJson(doc.data() as Map<String, dynamic>, doc.id);
            return ItensComId(id: doc.id, item: item);
          }).toList();
        });
  }

  void limparCampos() {
    Titulo.clear();
    Autor.clear();
    Editora.clear();
    Volume.clear();
    Preco.clear();
    Modelo.clear();
  }

  void sucesso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  void erro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }
}