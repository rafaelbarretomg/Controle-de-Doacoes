import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:flutter/material.dart';

import '../helpers/meu_texto.dart';

class Donatarios extends StatefulWidget {
  const Donatarios({super.key});

  @override
  State<Donatarios> createState() => _DonatariosState();
}

class _DonatariosState extends State<Donatarios> {
  List<Map<String, dynamic>> _listaDonatarios = [];

  bool _isLoading = true;

  // Função para pegar todos os donatarios
  void _refreshListaDonatarios() async {
    final data = await SQLHelper.getDonatarios();
    setState(() {
      _listaDonatarios = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshListaDonatarios(); // Carregar a lista quando o app inicia
  }

  final TextEditingController _nomeController = TextEditingController();

  final TextEditingController _obsController = TextEditingController();

  // Função para adicionar Donatario
  void _showForm(int? id) async {
    if (id != null) {
      final existingListaDonatarios =
          _listaDonatarios.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingListaDonatarios['nome'];
      _obsController.text = existingListaDonatarios['obs'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(hintText: 'Nome'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 5,
              controller: _obsController,
              decoration: const InputDecoration(hintText: 'Observação'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Salvar novo donatario
                if (id == null) {
                  await _addDonatario();
                }

                if (id != null) {
                  await _updateDonatario(id);
                }

                // limpar os campos
                _nomeController.text = '';
                _obsController.text = '';

                // fechar a aba
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text(id == null ? 'Cadastrar Novo' : 'Atualizar'),
            )
          ],
        ),
      ),
    );
  }

// Inserir um novo donatario
  Future<void> _addDonatario() async {
    await SQLHelper.createDonatario(_nomeController.text, _obsController.text);
    _refreshListaDonatarios();
  }

  // atualizar um donatario
  Future<void> _updateDonatario(int id) async {
    await SQLHelper.updateDonatario(
        id, _nomeController.text, _obsController.text);
    _refreshListaDonatarios();
  }

  // deletar um donatario
  void _deleteDonatario(int id) async {
    await SQLHelper.deleteDonatario(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Donatário deletado com sucesso!'),
    ));
    _refreshListaDonatarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        centerTitle: true,
        title: const MeuTexto(
          text: 'Cadastro de Donatários',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listaDonatarios.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(5),
                child: Row(children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MeuTexto(
                              text: 'Nome:',
                              size: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            MeuTexto(text: _listaDonatarios[index]['nome']),
                          ],
                        ),
                        Row(
                          children: [
                            const MeuTexto(
                              text: 'Obs:',
                              size: 12,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            MeuTexto(
                              text: _listaDonatarios[index]['obs'],
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showForm(_listaDonatarios[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _showMyDialog(_listaDonatarios[index]['id']),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }

  // funcao dialog de deletar
  Future<void> _showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente deletar o Donatário?'),
          actions: <Widget>[
            TextButton(
              child: const MeuTexto(
                text: 'Cancelar',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const MeuTexto(
                text: 'Confirmar',
                color: Colors.white,
              ),
              onPressed: () async {
                _deleteDonatario(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
