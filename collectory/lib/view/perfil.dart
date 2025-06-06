import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/usuario_controller.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final ctrl = GetIt.I.get<UsuarioController>();
  bool editando = false;

  @override
  void initState() {
    super.initState();
    ctrl.carregarPerfil();
    ctrl.addListener(() => setState(() {}));
    carregarPerfil();
  }

  void carregarPerfil() async {
    await ctrl.carregarPerfil();
    setState(() {});
  }

  void toggleEdicao() async {
    if (editando) {
      await ctrl.atualizarPerfil(context);
    }
    setState(() {
      editando = !editando;
    });
  }

  Widget buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: isDark ? Colors.grey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.person, size: 72, color: Color.fromARGB(255, 2, 134, 196)),
                const SizedBox(height: 16),
                buildTextField("Nome", ctrl.Nome, enabled: editando),
                buildTextField("Email", ctrl.Email, enabled: false),
                buildTextField("Telefone", ctrl.Telefone, enabled: editando),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: toggleEdicao,
                    icon: Icon(
                      editando ? Icons.save : Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      editando ? 'Salvar alterações' : 'Editar perfil',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: editando ? Colors.green : Color.fromARGB(255, 2, 134, 196),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}