import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/meu_texto.dart';
import '../helpers/meus_botoes.dart';

class Saidas extends StatefulWidget {
  const Saidas({super.key});

  @override
  State<Saidas> createState() => _SaidasState();
}

class _SaidasState extends State<Saidas> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _refreshListaSaidas();
  }

  List<Map<String, dynamic>> _listaSaidas = [];
  // funcao pegar lista de saidas
  void _refreshListaSaidas() async {
    final data = await SQLHelper.getSaidas();
    setState(() {
      _listaSaidas = data;
    });
    Future.delayed(
        const Duration(
          milliseconds: 200,
        ), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  final f = DateFormat('dd/MM/yyyy hh:mm', 'pt_Br');
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
          text: 'Saídas',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MeusBotoes(
                  onTap: () {
                    Navigator.pushNamed(context, '/add_saidas');
                  },
                  text: 'Adicionar Saída'),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _listaSaidas.length,
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
                                    text: 'Nome: ',
                                    size: 12,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MeuTexto(
                                    text: _listaSaidas[index]['nome'],
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const MeuTexto(
                                    text: 'Valor: ',
                                    size: 12,
                                    weight: FontWeight.bold,
                                  ),
                                  MeuTexto(
                                    text: ' R\$ '
                                        '${_listaSaidas[index]['valor'].toString().replaceAll('.', ',')}',
                                    size: 13,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const MeuTexto(
                                    text: 'Data: ',
                                    size: 12,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MeuTexto(
                                    text: f.format(DateTime.parse(
                                            _listaSaidas[index]['createdAt'])
                                        .toLocal()),
                                    size: 12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const MeuTexto(
                                    text: 'Obs:',
                                    size: 12,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MeuTexto(
                                    text: _listaSaidas[index]['obs'],
                                    size: 13,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(children: [
                            IconButton(
                              onPressed: () async {
                                _showForm(_listaSaidas[index]['id']);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                _showMyDialog(_listaSaidas[index]['id']);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ]),
                        )
                      ]),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  // controladores
  TextEditingController nomeController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController obsController = TextEditingController();

  // Função mostrar formulario add donatario
  void _showForm(int? id) async {
    if (id != null) {
      final existingListaSaidas =
          _listaSaidas.firstWhere((element) => element['id'] == id);
      nomeController.text = existingListaSaidas['nome'];
      valorController.text = existingListaSaidas['valor'].toString();
      obsController.text = existingListaSaidas['obs'];
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
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: valorController,
                    decoration: const InputDecoration(hintText: 'Valor'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLines: 5,
                    controller: obsController,
                    decoration: const InputDecoration(hintText: 'Observação'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id != null) {
                        await _updateSaidas(id);
                      }

                      // Close the bottom sheet
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text('Atualizar'),
                  )
                ],
              ),
            ));
  }

  // funcao atualizar saidas
  Future<void> _updateSaidas(int id) async {
    double valor = double.parse(valorController.text);
    await SQLHelper.updateSaida(
        id, nomeController.text, valor, obsController.text);
    _refreshListaSaidas();
  }

  // Função mostrar dialogo de deletar
  Future<void> _showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente deletar a Saída?'),
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
                _deleteSaida(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Funcao deletar
  void _deleteSaida(int id) async {
    await SQLHelper.deleteSaida(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Saída deletada com sucesso'),
    ));
    _refreshListaSaidas();
  }
}
