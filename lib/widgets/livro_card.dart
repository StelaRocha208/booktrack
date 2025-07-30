import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../screens/detalhes_screen.dart';

class LivroCard extends StatelessWidget {
  final Livro livro;
  final VoidCallback onAdicionar;

  const LivroCard({super.key, required this.livro, required this.onAdicionar});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalhesScreen(
                livro: livro,
                onSelecionarCategoria: (categoria) {
                  livro.categoria = categoria;
                  onAdicionar();
                },
              ),
            ),
          );
        },
        leading: Image.asset(livro.imagemAsset, width: 50),
        title: Text(livro.titulo),
        subtitle: Text('${livro.autor}\n${livro.descricao}'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: onAdicionar,
          child: const Text('Adicionar Livro'),
        ),
      ),
    );
  }
}
