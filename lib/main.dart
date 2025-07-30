import 'package:flutter/material.dart';
import 'screens/catalogo_screen.dart';
import 'screens/estante_screen.dart';
import 'models/livro.dart';

void main() {
  runApp(const BookTrackApp());
}

class BookTrackApp extends StatefulWidget {
  const BookTrackApp({super.key});

  @override
  State<BookTrackApp> createState() => _BookTrackAppState();
}

class _BookTrackAppState extends State<BookTrackApp> {
  final List<Livro> estante = [];

  int paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    final telas = [
      CatalogoScreen(estante: estante),
      EstanteScreen(estante: estante),
    ];

    return MaterialApp(
      home: Scaffold(
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Catálogo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Estante',
            ),
          ],
        ),
      ),
    );
  }
}
