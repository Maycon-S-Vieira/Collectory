import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/itens_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item_model.dart';

class FiltrosView extends StatefulWidget {
  const FiltrosView({super.key});

  @override
  State<FiltrosView> createState() => _FiltrosViewState();
}

class _FiltrosViewState extends State<FiltrosView> {
  final ctrl = GetIt.I.get<ItemController>();

  final tituloCtrl = TextEditingController();
  final autorCtrl = TextEditingController();
  final editoraCtrl = TextEditingController();
  final precoMinCtrl = TextEditingController();
  final precoMaxCtrl = TextEditingController();
  final volumeMinCtrl = TextEditingController();
  final volumeMaxCtrl = TextEditingController();

  String ordenacao = 'titulo_asc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtros')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: tituloCtrl, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: autorCtrl, decoration: InputDecoration(labelText: 'Autor')),
            TextField(controller: editoraCtrl, decoration: InputDecoration(labelText: 'Editora')),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: precoMinCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Preço Mín'))),
                SizedBox(width: 10),
                Expanded(child: TextField(controller: precoMaxCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Preço Máx'))),
              ],
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: volumeMinCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Volume Mín'))),
                SizedBox(width: 10),
                Expanded(child: TextField(controller: volumeMaxCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Volume Máx'))),
              ],
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: ordenacao,
              items: [
                DropdownMenuItem(child: Text('Título (A-Z)'), value: 'titulo_asc'),
                DropdownMenuItem(child: Text('Título (Z-A)'), value: 'titulo_desc'),
                DropdownMenuItem(child: Text('Preço (menor)'), value: 'preco_asc'),
                DropdownMenuItem(child: Text('Preço (maior)'), value: 'preco_desc'),
              ],
              onChanged: (value) => setState(() => ordenacao = value!),
              decoration: InputDecoration(labelText: 'Ordenar por'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final resultados = await aplicarFiltros();
                if (resultados.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    'visualizar',
                    arguments: resultados,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nenhum item encontrado')),
                  );
                }
              },
              child: Text('Buscar'),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Itens>> aplicarFiltros() async {
    final uid = ctrl.usuarioCtrl.idUsuario();
    if (uid == null) return [];

    Query query = FirebaseFirestore.instance.collection('itens')
        .where('uid', isEqualTo: uid);

    if (tituloCtrl.text.isNotEmpty) {
      query = query.where('titulo', isEqualTo: tituloCtrl.text);
    }
    if (autorCtrl.text.isNotEmpty) {
      query = query.where('autor', isEqualTo: autorCtrl.text);
    }
    if (editoraCtrl.text.isNotEmpty) {
      query = query.where('editora', isEqualTo: editoraCtrl.text);
    }

    final snapshot = await query.get();
    var lista = snapshot.docs.map((doc) {
      return Itens.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // Filtros de faixa (preço e volume)
    double? precoMin = double.tryParse(precoMinCtrl.text);
    double? precoMax = double.tryParse(precoMaxCtrl.text);
    int? volumeMin = int.tryParse(volumeMinCtrl.text);
    int? volumeMax = int.tryParse(volumeMaxCtrl.text);

    lista = lista.where((item) {
      final dentroPreco = (precoMin == null || item.preco >= precoMin) &&
                          (precoMax == null || item.preco <= precoMax);
      final dentroVolume = (volumeMin == null || item.volume >= volumeMin) &&
                           (volumeMax == null || item.volume <= volumeMax);
      return dentroPreco && dentroVolume;
    }).toList();

    // Ordenação
    lista.sort((a, b) {
      switch (ordenacao) {
        case 'titulo_asc':
          return a.titulo.compareTo(b.titulo);
        case 'titulo_desc':
          return b.titulo.compareTo(a.titulo);
        case 'preco_asc':
          return a.preco.compareTo(b.preco);
        case 'preco_desc':
          return b.preco.compareTo(a.preco);
        default:
          return 0;
      }
    });

    return lista;
  }
}