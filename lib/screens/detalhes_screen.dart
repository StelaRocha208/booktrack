import 'package:flutter/material.dart';
import '../models/livro.dart';

class DetalhesScreen extends StatelessWidget {
  final Livro livro;
  final Function(String) onSelecionarCategoria;

  const DetalhesScreen({
    super.key,
    required this.livro,
    required this.onSelecionarCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(livro.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(livro.imagemAsset, width: 100),
            const SizedBox(height: 16),
            Text(
              livro.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Autor: ${livro.autor}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(livro.descricao),
            const SizedBox(height: 24),
            const Text("Adicionar à estante em:"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Quero Ler', 'Lendo', 'Lido'].map((categoria) {
                return ElevatedButton(
                  onPressed: () {
                    onSelecionarCategoria(categoria);
                    Navigator.pop(context);
                  },
                  child: Text(categoria),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
