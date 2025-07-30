import 'package:flutter/material.dart';
import '../data/catalogo_mock.dart';
import '../models/livro.dart';
import '../widgets/livro_card.dart';

class CatalogoScreen extends StatefulWidget {
  final List<Livro> estante;

  const CatalogoScreen({super.key, required this.estante});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  void adicionarComCategoria(Livro livro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selecione a categoria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Quero Ler', 'Lendo', 'Lido'].map((categoria) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  livro.categoria = categoria;
                  widget.estante.add(livro);
                });
                Navigator.pop(context);
              },
              child: Text(categoria),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: catalogoLivros.map((livro) {
        return LivroCard(
          livro: livro,
          onAdicionar: () => adicionarComCategoria(livro),
        );
      }).toList(),
    );
  }
}
