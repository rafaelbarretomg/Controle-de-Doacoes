import 'package:flutter/material.dart';

import 'meu_texto.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.lightBlue),
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: const MeuTexto(
              text: 'Página Inicial',
            ),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: const MeuTexto(text: 'Entradas de Doações'),
            onTap: () {
              Navigator.pushNamed(context, '/entradas');
            },
          ),
          ListTile(
            title: const MeuTexto(text: 'Saídas de Doações'),
            onTap: () {
              Navigator.pushNamed(context, '/saidas');
            },
          ),
          ListTile(
            title: const MeuTexto(text: 'Cadastrar Doadores'),
            onTap: () {
              Navigator.pushNamed(context, '/doadores');
            },
          ),
          ListTile(
            title: const MeuTexto(text: 'Cadastrar Donatários'),
            onTap: () {
              Navigator.pushNamed(context, '/donatarios');
            },
          ),
          ListTile(
            title: Row(
              children: const [
                MeuTexto(text: 'Dinheiro em Caixa'),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/caixa');
            },
          ),
          ListTile(
            title: const MeuTexto(text: 'Sobre'),
            onTap: () {
              Navigator.pushNamed(context, '/sobre');
            },
          )
        ],
      ),
    );
  }
}
