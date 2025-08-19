import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livro.dart';
import 'detalhes_screen.dart';
import 'resenha_screen.dart';

class EstanteScreen extends StatelessWidget {
  final categorias = ['Quero Ler', 'Lendo', 'Lido'];

  EstanteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final estanteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('estante');

    return DefaultTabController(
      length: categorias.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F0),
        body: Column(
          children: [
            // SafeArea aplicado apenas no topo para proteger o header e tabs
            SafeArea(
              bottom: false, // não aplicar SafeArea na parte inferior aqui
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: const Color(0xFFA65638),
                    child: const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Minha Estante',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xFFA65638),
                    child: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: categorias.map((c) => Tab(text: c)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: estanteRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return TabBarView(
                      children: categorias.map((c) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum livro em "$c"',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Adicione livros do catálogo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  final livros = docs.map((d) {
                    final data = d.data();
                    return Livro(
                      id: d.id,
                      titulo: data['titulo'] as String,
                      autor: data['autor'] as String,
                      descricao: data['descricao'] as String,
                      imagemAsset: data['imagemAsset'] as String,
                      categoria: data['categoria'] as String,
                    );
                  }).toList();
                  return TabBarView(
                    children: categorias.map((c) {
                      final subset = livros.where((l) => l.categoria == c).toList();
                      if (subset.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum livro em "$c"',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF8B4513),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Adicione livros do catálogo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        // SafeArea aplicado no padding para proteger o conteúdo inferior
                        padding: EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          16 + MediaQuery.of(context).padding.bottom,
                        ),
                        itemCount: subset.length,
                        itemBuilder: (context, i) {
                          final livro = subset[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhesScreen(
                                    livro: livro,
                                    estante: subset,
                                    onAdicionarLivro: (_, __) {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F0),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      livro.imagemAsset,
                                      width: 96,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 96,
                                        height: 120,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.book,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          livro.titulo,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          livro.autor,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          livro.descricao,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        if (livro.categoria == 'Lido')
                                          SizedBox(
                                            width: 160,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => ResenhaScreen(
                                                      livro: livro,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFBF6E3F),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                              ),
                                              child: const Text(
                                                'Adicionar resenha',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF8B4513),
                                    ),
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                        value: 'mover',
                                        child: Text('Mover categoria'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'remover',
                                        child: Text('Remover'),
                                      ),
                                    ],
                                    onSelected: (v) async {
                                      final docId = livro.id.toString();
                                      if (v == 'remover') {
                                        await estanteRef.doc(docId).delete();
                                      } else if (v == 'mover') {
                                        final next = categorias
                                            .where((x) => x != livro.categoria)
                                            .toList();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext dialogContext) =>
                                              AlertDialog(
                                            title: const Text('Mover para'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: next.map((cat) {
                                                return ElevatedButton(
                                                  onPressed: () async {
                                                    await estanteRef
                                                        .doc(docId)
                                                        .update({'categoria': cat});
                                                    Navigator.of(dialogContext).pop();
                                                  },
                                                  child: Text(cat),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}