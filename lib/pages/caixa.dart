import 'package:controle_de_doacoes/database/sql_helper.dart';
import 'package:flutter/material.dart';

import '../helpers/meu_texto.dart';

class Caixa extends StatefulWidget {
  const Caixa({super.key});

  @override
  State<Caixa> createState() => _CaixaState();
}

class _CaixaState extends State<Caixa> {
  @override
  void initState() {
    super.initState();
    _refreshListaEntradas();
    _valorTodasEntradas();
    _valorTodasSaidas();
  }

  bool _isLoading = true;

  void _refreshListaEntradas() async {
    Future.delayed(
        const Duration(
          milliseconds: 300,
        ), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  double caixa = 0.00;
  double valorEntrada = 0.00;
  //funcao somar entradas
  Future<double> _valorTodasEntradas() async {
    var soma1 = await SQLHelper.somaEntradas();
    soma1 ??= 0.0;
    valorEntrada = soma1;
    return soma1;
  }

  // funcao somar saidas
  double valorSaida = 0.00;
  Future<double> _valorTodasSaidas() async {
    var soma1 = await SQLHelper.somaSaidas();
    soma1 ??= 0.0;
    valorSaida = soma1;
    return soma1;
  }

  @override
  Widget build(BuildContext context) {
    double caixa = valorEntrada - valorSaida;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        centerTitle: true,
        title: const MeuTexto(
          text: 'Caixa',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: MeuTexto(
                      text: 'Valor em Caixa',
                      size: 50,
                      weight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MeuTexto(
                    text:
                        'R\$ = ${caixa.toStringAsFixed(2).replaceAll('.', ',')}',
                    size: 40,
                  )
                ],
              ),
            ),
    );
  }
}
