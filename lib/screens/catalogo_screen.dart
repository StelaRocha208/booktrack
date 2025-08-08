import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/catalogo_mock.dart';
import '../models/livro.dart';
import 'detalhes_screen.dart';

class CatalogoScreen extends StatefulWidget {
  final List<Livro> estante; // seu catálogo estático
  const CatalogoScreen({Key? key, required this.estante}) : super(key: key);

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final _searchController = TextEditingController();
  List<Livro> _filteredLivros = [];
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late final CollectionReference<Map<String, dynamic>> _estanteRef;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _sub;
  Set<String> _idsNaEstante = {};

  @override
  void initState() {
    super.initState();
    _filteredLivros = catalogoLivros;
    _searchController.addListener(_filterLivros);

    _estanteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('estante');

    // escuta Firestore e atualiza o set de IDs
    _sub = _estanteRef.snapshots().listen((snap) {
      setState(() {
        _idsNaEstante = snap.docs.map((d) => d.id).toSet();
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _searchController
      ..removeListener(_filterLivros)
      ..dispose();
    super.dispose();
  }

  void _filterLivros() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredLivros =
          q.isEmpty
              ? catalogoLivros
              : catalogoLivros.where((l) {
                return l.titulo.toLowerCase().contains(q) ||
                    l.autor.toLowerCase().contains(q);
              }).toList();
    });
  }

  bool _jaAdicionado(Livro livro) {
    return _idsNaEstante.contains(livro.id.toString());
  }

  Future<void> _adicionarComCategoria(Livro livro) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF2F2F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Selecione a categoria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['Quero Ler', 'Lendo', 'Lido'].map((categoria) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBF6E3F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () async {
                        // grava no Firestore
                        await _estanteRef.doc(livro.id).set({
                          'id': livro.id,
                          'titulo': livro.titulo,
                          'autor': livro.autor,
                          'descricao': livro.descricao,
                          'imagemAsset': livro.imagemAsset,
                          'categoria': categoria,
                          'addedAt': Timestamp.now(),
                        });
                        // fecha o diálogo
                        Navigator.of(dialogContext).pop();
                        // SnackBar de confirmação
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Livro adicionado à categoria $categoria',
                            ),
                            backgroundColor: const Color(0xFFB87333),
                          ),
                        );
                      },
                      child: Text(categoria),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      body: Column(
        children: [
          // seu header...
          Container(
            width: double.infinity,
            height: 100,
            color: const Color(0xFFA65638),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'BookTrack',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // search bar...
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Pesquisar livro',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),

          // lista de livros
          Expanded(
            child:
                _filteredLivros.isEmpty
                    ? const Center(
                      child: Text(
                        'Nenhum livro encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredLivros.length,
                      itemBuilder: (_, i) {
                        final livro = _filteredLivros[i];
                        final ja = _jaAdicionado(livro);
                        return GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DetalhesScreen(
                                        livro: livro,
                                        estante: widget.estante,
                                        onAdicionarLivro: (_, __) {},
                                      ),
                                ),
                              ),
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
                              children: [
                                // thumbnail...
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    livro.imagemAsset,
                                    width: 80,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          width: 80,
                                          height: 100,
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
                                // info + botão
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        livro.titulo,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        livro.autor,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: 250,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ja
                                                    ? const Color(0xFF4CAF50)
                                                    : const Color(0xFFBF6E3F),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                          ),
                                          onPressed:
                                              ja
                                                  ? null
                                                  : () => _adicionarComCategoria(
                                                    livro,
                                                  ),
                                          icon: Icon(
                                            ja
                                                ? Icons.check_circle
                                                : Icons.book,
                                            size: 20,
                                          ),
                                          label: Text(
                                            ja
                                                ? 'Adicionado à Estante'
                                                : 'Adicionar Livro',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
