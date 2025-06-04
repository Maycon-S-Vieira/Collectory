import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioController extends ChangeNotifier {
  final Nome = TextEditingController();
  final Email = TextEditingController();
  final Telefone = TextEditingController();
  final Senha = TextEditingController();
  final ConfirmaSenha = TextEditingController();
  final EmailEsqueceuSenha = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  //
  // Criar usuário e salvar dados no Firestore
  //

  Future<void> criarConta(BuildContext context) async {
  try {
    final s = await auth.createUserWithEmailAndPassword(
      email: Email.text.trim(),
      password: Senha.text.trim(),
    );

    // Salvar dados no Firestore com UID como ID
    await FirebaseFirestore.instance.collection('usuarios').doc(s.user!.uid).set({
      'nome': Nome.text.trim(),
      'email': Email.text.trim(),
      'telefone': Telefone.text.trim(),
      'criado_em': DateTime.now(),
    });

    sucesso(context, 'Usuário criado com sucesso!');
    limparCampos();
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    String mensagem;
    switch (e.code) {
      case 'email-already-in-use':
        mensagem = 'Este e-mail já está em uso.';
        break;
      case 'invalid-email':
        mensagem = 'E-mail inválido.';
        break;
      case 'weak-password':
        mensagem = 'A senha deve conter pelo menos 6 caracteres.';
        break;
      default:
        mensagem = 'Erro: ${e.message}';
    }
    erro(context, mensagem);
  } catch (e) {
    erro(context, 'Erro inesperado ao salvar dados no Firestore.');
  }
}
 
  //
  // Fazer login
  //
  Future<bool> login(BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: Email.text.trim(),
        password: Senha.text.trim(),
      );
      sucesso(context, 'Login realizado com sucesso!');
      return true;
    } catch (e) {
      String mensagem = 'Erro desconhecido';

      try {
        final fe = e as FirebaseAuthException;
        switch (fe.code) {
          case 'invalid-email':
            mensagem = 'E-mail inválido.';
            break;
          case 'user-not-found':
            mensagem = 'Usuário não encontrado.';
            break;
          case 'wrong-password':
            mensagem = 'Senha incorreta.';
            break;
          default:
            mensagem = 'Erro: ${fe.message}';
        }
      } catch (_) {
        mensagem = 'Erro inesperado: ${e.toString()}';
      }

      erro(context, mensagem);
      return false;
    }
  }

  //
  // Recuperar senha
  //
  void esqueceuSenha(BuildContext context) {
    auth.sendPasswordResetEmail(email: EmailEsqueceuSenha.text.trim())
        .then((_) {
      sucesso(context, 'E-mail de recuperação enviado com sucesso!');
      EmailEsqueceuSenha.clear();
      Navigator.pop(context);
    }).catchError((e) {
      String mensagem;
      switch (e.code) {
        case 'invalid-email':
          mensagem = 'O e-mail informado é inválido.';
          break;
        case 'user-not-found':
          mensagem = 'Nenhum usuário encontrado com este e-mail.';
          break;
        default:
          mensagem = 'Erro: ${e.message}';
      }
      erro(context, mensagem);
    });
  }

  //
  // Buscar perfil do usuário logado
  //
  Future<void> carregarPerfil() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        Nome.text = data['nome'] ?? '';
        Email.text = data['email'] ?? '';
        Telefone.text = data['telefone'] ?? '';
      }
    }
  }

  void limparCampos() {
    Nome.clear();
    Email.clear();
    Telefone.clear();
    Senha.clear();
    ConfirmaSenha.clear();
  }

  String? idUsuario() {
    return auth.currentUser?.uid ?? '';
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