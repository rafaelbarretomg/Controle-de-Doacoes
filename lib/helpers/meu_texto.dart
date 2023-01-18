import 'package:flutter/material.dart';

class MeuTexto extends StatelessWidget {
  const MeuTexto(
      {Key? key,
      required this.text,
      this.size = 16,
      this.color = Colors.black,
      this.weight = FontWeight.normal})
      : super(key: key);

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight),
      overflow: TextOverflow.ellipsis,
    );
  }
}
