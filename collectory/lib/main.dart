import 'package:collectory/controller/collectory_controller.dart';
import 'package:collectory/view/cadastro.dart';
import 'package:collectory/view/login.dart';
import 'package:collectory/view/tela_inicial.dart';
import 'package:collectory/view/add_itens.dart';
import 'package:collectory/view/configuracoes.dart';
import 'package:collectory/view/excluir_itens.dart';
import 'package:collectory/view/filtros.dart';
import 'package:collectory/view/informacoes.dart';
import 'package:collectory/view/perfil.dart';
import 'package:collectory/view/recuperar_senha.dart';
import 'package:collectory/view/sobre.dart';
import 'package:collectory/view/visualizar_colecao.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final g = GetIt.instance;

void main() {

  g.registerSingleton<CollectoryController>(CollectoryController());

  runApp(DevicePreview(builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collectory',
      //
      //Navegação
      //
      initialRoute: 'sobre',
      routes: {
        'cadastro': (context) => const CadastroView(),
        'iniciar': (context) => const IniView(),
        'esqueceu': (context) => const RecuperarView(),
        'login': (context) => const LoginView(),
        'perfil': (context) => const PerfilView(),
        'configuracoes': (context) => const ConfiguracoesView(),
        'filtros': (context) => const FiltrosView(),
        'informacoes': (context) => const InformacoesView(),
        'excluir_itens': (context) => const ExcluirView(),
        'add_itens': (context) => const Add_Itens_View(),
        'sobre': (context) => const SobreView(),
        'visualizar': (context) => const Visualizar_Colecao_View(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
