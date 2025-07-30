import 'package:flutter/material.dart';
import '../models/livro.dart';

class EstanteScreen extends StatelessWidget {
  final List<Livro> estante;

  const EstanteScreen({super.key, required this.estante});

  @override
  Widget build(BuildContext context) {
    final categorias = ['Quero Ler', 'Lendo', 'Lido'];

    return DefaultTabController(
      length: categorias.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Estante'),
          bottom: TabBar(
            tabs: categorias.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: categorias.map((categoria) {
            final livrosCategoria =
                estante.where((l) => l.categoria == categoria).toList();
            return ListView.builder(
              itemCount: livrosCategoria.length,
              itemBuilder: (_, index) {
                final livro = livrosCategoria[index];
                return ListTile(
                  leading: Image.asset(livro.imagemAsset, width: 50),
                  title: Text(livro.titulo),
                  subtitle: Text(livro.autor),
                  trailing: Text(categoria),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

