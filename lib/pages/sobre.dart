import 'package:controle_de_doacoes/helpers/meu_texto.dart';
import 'package:flutter/material.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

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
          text: 'Sobre',
          size: 20,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MeuTexto(
              text: 'Aplicativo desenvolvido por Rafael Barreto.',
              size: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MeuTexto(
                  text: 'Contato: ',
                  size: 20,
                ),
                SelectableText(
                  'rafaelbarretomg@gmail.com',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const MeuTexto(
              text: 'Guaranésia 2023',
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
