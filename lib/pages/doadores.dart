import 'package:flutter/material.dart';

import '../database/sql_helper.dart';
import '../helpers/meu_texto.dart';

class Doadores extends StatefulWidget {
  const Doadores({super.key});

  @override
  State<Doadores> createState() => _DoadoresState();
}

class _DoadoresState extends State<Doadores> {
  List<Map<String, dynamic>> _listaDoadores = [];

  bool _isLoading = true;

  // funcao pegar lista doadores
  void _refreshListaDoadores() async {
    final data = await SQLHelper.getDoadores();
    setState(() {
      _listaDoadores = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshListaDoadores();
  }

  // controladores
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();

  // funcao formulario add doador
  void _showForm(int? id) async {
    if (id != null) {
      final existingListaDoadores =
          _listaDoadores.firstWhere((element) => element['id'] == id);
      _nomeController.text = existingListaDoadores['nome'];
      _obsController.text = existingListaDoadores['obs'];
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
                      // Salvar novo doador
                      if (id == null) {
                        await _addDoador();
                      }

                      if (id != null) {
                        await _updateDoador(id);
                      }

                      // Limpar os campos
                      _nomeController.text = '';
                      _obsController.text = '';

                      //Fechar a aba
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: Text(id == null ? 'Cadastrar Novo' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

// Inserir um Doador no bd
  Future<void> _addDoador() async {
    await SQLHelper.createDoador(_nomeController.text, _obsController.text);
    _refreshListaDoadores();
  }

  // Atualizar um doador no bd
  Future<void> _updateDoador(int id) async {
    await SQLHelper.updateDoador(id, _nomeController.text, _obsController.text);
    _refreshListaDoadores();
  }

  // Deletar um doador do bd
  void _deleteDoador(int id) async {
    await SQLHelper.deleteDoador(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Doador deletado com sucesso!'),
    ));
    _refreshListaDoadores();
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
          text: 'Cadastro de Doadores',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listaDoadores.length,
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
                            MeuTexto(text: _listaDoadores[index]['nome']),
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
                              text: _listaDoadores[index]['obs'],
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
                              _showForm(_listaDoadores[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _showMyDialog(_listaDoadores[index]['id']),
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
  // funcao dialogo de deletar
  Future<void> _showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente deletar o Doador?'),
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
                _deleteDoador(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
