import 'package:controle_de_doacoes/helpers/meu_texto.dart';
import 'package:flutter/material.dart';

class MeusBotoes extends StatelessWidget {
  const MeusBotoes({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: onTap,
        child: MeuTexto(text: text),
      ),
    );
  }
}
