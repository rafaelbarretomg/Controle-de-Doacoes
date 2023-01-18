import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:controle_de_doacoes/helpers/meus_botoes.dart';
import 'package:flutter/material.dart';

import '../../helpers/meu_texto.dart';

class AdicionarEntradas extends StatefulWidget {
  const AdicionarEntradas({
    super.key,
  });

  @override
  State<AdicionarEntradas> createState() => _AdicionarEntradasState();
}

class _AdicionarEntradasState extends State<AdicionarEntradas> {
  // controladores
  TextEditingController controladorDoNome = TextEditingController();
  TextEditingController controladorDaData = TextEditingController();
  TextEditingController controladorDoValor = TextEditingController();
  TextEditingController controladorDaObs = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshListaDoadores();
  }

  Future<void> _addEntrada() async {
    if (controladorDoValor.text.isEmpty) {
      controladorDoValor.text = '0';
    }
    double valor = double.parse(controladorDoValor.text);
    await SQLHelper.createEntrada(
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
          text: 'Adicionar Entradas',
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
                    Flexible(
                      child: TextFormField(
                        controller: controladorDoNome,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Doador',
                        ),
                      ),
                    ),
                    MeusBotoes(
                        onTap: () => _showForm(null), text: 'Add Doador'),
                  ],
                ),
                TextFormField(
                  controller: controladorDoValor,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(
                      labelText: 'Valor', prefixText: 'R\$ '),
                  
                ),
                TextFormField(
                  controller: controladorDaObs,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: MeusBotoes(
                    onTap: () async {
                      // salvar nova entrada
                      await _addEntrada();
                      if (!mounted) return;
                      Navigator.pushNamed(context, '/entradas');
                    },
                    text: 'Salvar',
                  ),
                )
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

  // Funcao do formulario de adicionar doadores
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
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
                      // Adiciona novo Doador

                      await _addDoador();

                      // fecha pagina
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: Text(id == null ? 'Cadastrar Novo' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

  // Função add doador
  Future<void> _addDoador() async {
    await SQLHelper.createDoador(_nomeController.text, _obsController.text);
    _refreshListaDoadores();
  }

  // funcao para pegar lista de doadores
  void _refreshListaDoadores() async {
    final data = await SQLHelper.getDoadores();
    setState(() {
      _listaDoadores = data;
    });
  }

  List<Map<String, dynamic>> _listaDoadores = [];
}
