import 'package:controle_de_doacoes/helpers/meu_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final bool readOnly;
  final Function()? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final String? prefixText;
  final String? hintText;
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.focus = false,
    this.readOnly = false,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.prefixText,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool focus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(),
          bottom: BorderSide(),
          left: BorderSide(),
          right: BorderSide(),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Center(
                child: MeuTexto(
                  text: label,
                  weight: FontWeight.bold,
                  size: 14,
                ),
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 30,
              child: TextFormField(
                readOnly: readOnly,
                style: const TextStyle(fontSize: 14),
                autofocus: focus,
                onTap: onTap,
                controller: controller,
                onEditingComplete: onEditingComplete,
                inputFormatters: inputFormatters,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                    prefixText: prefixText,
                    hintText: hintText,
                    filled: true,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.only(left: 8, bottom: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
