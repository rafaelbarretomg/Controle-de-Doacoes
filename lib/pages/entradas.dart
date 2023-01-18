import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/meu_texto.dart';
import '../helpers/meus_botoes.dart';

class Entradas extends StatefulWidget {
  const Entradas({super.key});

  @override
  State<Entradas> createState() => _EntradasState();
}

class _EntradasState extends State<Entradas> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _refreshListaEntradas();
  }

  List<Map<String, dynamic>> _listaEntradas = [];
  void _refreshListaEntradas() async {
    final data = await SQLHelper.getEntradas();
    setState(() {
      _listaEntradas = data;
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
          text: 'Entradas',
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
                    Navigator.pushNamed(context, '/add_entradas');
                  },
                  text: 'Adicionar Entrada'),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _listaEntradas.length,
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
                              Row(children: [
                                const MeuTexto(
                                  text: 'Nome: ',
                                  size: 12,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                MeuTexto(
                                  text: _listaEntradas[index]['nome'],
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
                                      '${_listaEntradas[index]['valor'].toString().replaceAll('.', ',')}',
                                  size: 13,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ]),
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
                                            _listaEntradas[index]['createdAt'])
                                        .toLocal()),
                                    size: 12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const MeuTexto(
                                    text: 'Obs: ',
                                    size: 12,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MeuTexto(
                                    text: _listaEntradas[index]['obs'],
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
                                _showForm(_listaEntradas[index]['id']);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                _showMyDialog(_listaEntradas[index]['id']);
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

  TextEditingController nomeController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController obsController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item

      final existingListaEntradas =
          _listaEntradas.firstWhere((element) => element['id'] == id);
      nomeController.text = existingListaEntradas['nome'];
      valorController.text = existingListaEntradas['valor'].toString();
      obsController.text = existingListaEntradas['obs'];
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
                        await _updateEntradas(id);
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

  Future<void> _updateEntradas(int id) async {
    double valor = double.parse(valorController.text);
    await SQLHelper.updateEntrada(
        id, nomeController.text, valor, obsController.text);
    _refreshListaEntradas();
  }

  Future<void> _showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente deletar a Entrada?'),
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
                _deleteEntrada(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // funcao deletar entradas
  void _deleteEntrada(int id) async {
    await SQLHelper.deleteEntradas(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Entrada deletada com Sucesso!'),
    ));
    _refreshListaEntradas();
  }
}
