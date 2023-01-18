import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:controle_de_doacoes/helpers/meus_botoes.dart';
import 'package:flutter/material.dart';

import '../../helpers/meu_texto.dart';

class AdicionarSaidas extends StatefulWidget {
  const AdicionarSaidas({
    super.key,
  });

  @override
  State<AdicionarSaidas> createState() => _AdicionarSaidasState();
}

class _AdicionarSaidasState extends State<AdicionarSaidas> {
  TextEditingController controladorDoNome = TextEditingController();
  TextEditingController controladorDaData = TextEditingController();
  TextEditingController controladorDoValor = TextEditingController();
  TextEditingController controladorDaObs = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshListaDonatarios();
  }

  // Função de add saída
  Future<void> _addSaida() async {
    if (controladorDoValor.text.isEmpty) {
      controladorDoValor.text = '0';
    }
    double valor = double.parse(controladorDoValor.text);
    await SQLHelper.createSaida(
      controladorDoNome.text,
      valor,
      controladorDaObs.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const MeuTexto(
          text: 'Adicionar Saídas',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: controladorDoNome,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Donatário',
                        ),
                      ),
                    ),
                    MeusBotoes(
                        onTap: () => _showForm(null), text: 'Add Donatário'),
                  ],
                ),
                TextFormField(
                  controller: controladorDoValor,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(
                      labelText: 'Valor', prefixText: 'R\$ '),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 5,
                ),
                Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: MeusBotoes(
                      onTap: () async {
                        // salvar nova saída
                        _addSaida();
                        if (!mounted) return;
                        Navigator.pushNamed(context, '/saidas');
                      },
                      text: 'Salvar',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //controladores
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();
  List<Map<String, dynamic>> _listaDonatarios = [];

  //Função para add donatário
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
                // Add novo donatario
                if (id == null) {
                  await _addDonatario();
                }

                // limpa campos
                _nomeController.text = '';
                _obsController.text = '';

                // fecha aba
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

  // insere um novo donatario
  Future<void> _addDonatario() async {
    await SQLHelper.createDonatario(_nomeController.text, _obsController.text);
    _refreshListaDonatarios();
  }

  void _refreshListaDonatarios() async {
    final data = await SQLHelper.getDonatarios();
    setState(() {
      _listaDonatarios = data;
    });
  }
}
