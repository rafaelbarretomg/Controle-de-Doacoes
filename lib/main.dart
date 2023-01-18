import 'package:controle_de_doacoes/pages/caixa.dart';
import 'package:controle_de_doacoes/pages/doadores.dart';
import 'package:controle_de_doacoes/pages/donatarios.dart';

import 'package:controle_de_doacoes/pages/sobre.dart';
import 'package:controle_de_doacoes/pages/subpages/adicionar_entradas.dart';
import 'package:controle_de_doacoes/pages/subpages/adicionar_saidas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/pagina_inicial.dart';
import 'pages/saidas.dart';
import 'pages/entradas.dart';

Future<void> main() async {
  //iniciando o banco de dados
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Doações',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      // rotas das paginas
      routes: {
        '/': (context) => const PaginaInicial(),
        '/entradas': (context) => const Entradas(),
        '/saidas': (context) => const Saidas(),
        '/caixa': (context) => const Caixa(),
        '/doadores': (context) => const Doadores(),
        '/donatarios': (context) => const Donatarios(),
        '/add_entradas': (context) => const AdicionarEntradas(),
        '/add_saidas': (context) => const AdicionarSaidas(),
        '/sobre': (context) => const Sobre(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
