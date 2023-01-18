import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/meu_drawer.dart';
import '../helpers/meu_texto.dart';
import '../helpers/meus_botoes.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({
    super.key,
  });

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  void initState() {
    super.initState();
    _refreshListaEntradasI();
    _refreshListaSaidasI();
  }

  List<Map<String, dynamic>> _listaEntradas = [];
  List<Map<String, dynamic>> _listaSaidas = [];

  // pegar todas entradas com limite
  void _refreshListaEntradasI() async {
    final data = await SQLHelper.getEntradasI();
    setState(() {
      _listaEntradas = data;
    });
    Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () {});
  }

  //pegar saidas com limite
  void _refreshListaSaidasI() async {
    final data = await SQLHelper.getSaidasI();
    setState(() {
      _listaSaidas = data;
    });
    Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () {});
  }

  final f = DateFormat('dd/MM/yyyy hh:mm', 'pt_Br');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const MeuTexto(
          text: 'Controle de Doações',
          color: Colors.white,
          size: 20,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MeusBotoes(
                text: 'Entradas',
                onTap: () {
                  Navigator.pushNamed(context, '/entradas');
                },
              ),
              MeusBotoes(
                text: 'Saídas',
                onTap: () {
                  Navigator.pushNamed(context, '/saidas');
                },
              ),
              MeusBotoes(
                text: 'Caixa',
                onTap: () {
                  Navigator.pushNamed(context, '/caixa');
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MeusBotoes(
                text: 'Doadores',
                onTap: () {
                  Navigator.pushNamed(context, '/doadores');
                },
              ),
              MeusBotoes(
                text: 'Donatários',
                onTap: () {
                  Navigator.pushNamed(context, '/donatarios');
                },
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Center(
              child: MeuTexto(
                text: 'Ultimas Entradas',
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaEntradas.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(5),
                child: Row(children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            text: _listaEntradas[index]['nome'],
                            size: 14,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const MeuTexto(
                            text: 'Valor:',
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
                                    _listaEntradas[index]['createdAt'])
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
                            text: _listaEntradas[index]['obs'],
                            size: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.green),
            child: const Center(
              child: MeuTexto(
                text: 'Ultimas Saídas',
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaSaidas.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(2),
                child: Row(children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            text: f.format(
                                DateTime.parse(_listaSaidas[index]['createdAt'])
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
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
