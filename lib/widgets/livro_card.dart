import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../screens/detalhes_screen.dart';

class LivroCard extends StatelessWidget {
  final Livro livro;
  final List<Livro> estante;
  final Function(Livro, String) onAdicionarLivro;

  const LivroCard({
    super.key,
    required this.livro,
    required this.estante,
    required this.onAdicionarLivro,
  });

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
                estante: estante,
                onAdicionarLivro: onAdicionarLivro,
              ),
            ),
          );
        },
        leading: Image.asset(livro.imagemAsset, width: 50),
        title: Text(livro.titulo),
        subtitle: Text('${livro.autor}\n${livro.descricao}'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: () => onAdicionarLivro(livro, 'Quero Ler'),
          child: const Text('Adicionar Livro'),
        ),
      ),
    );
  }
}

