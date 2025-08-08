import 'package:flutter/material.dart';
import 'catalogo_screen.dart';
import 'estante_screen.dart';
import '../models/livro.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int paginaAtual = 0;
  final List<Livro> estante = [];

  @override
  Widget build(BuildContext context) {
    final telas = [
      CatalogoScreen(estante: estante),
      EstanteScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('BookTrack')),
      body: telas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Catálogo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Estante',
          ),
        ],
      ),
    );
  }
}
