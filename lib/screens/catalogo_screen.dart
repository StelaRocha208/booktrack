import 'package:flutter/material.dart';
import '../data/catalogo_mock.dart';
import '../models/livro.dart';
import 'detalhes_screen.dart'; // Importe a tela de detalhes

class CatalogoScreen extends StatefulWidget {
  final List<Livro> estante;
  const CatalogoScreen({Key? key, required this.estante}) : super(key: key);

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Livro> _filteredLivros = [];

  @override
  void initState() {
    super.initState();
    _filteredLivros = catalogoLivros;
    _searchController.addListener(_filterLivros);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLivros);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLivros() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filteredLivros = q.isEmpty
          ? catalogoLivros
          : catalogoLivros.where((l) {
              return l.titulo.toLowerCase().contains(q) ||
                  l.autor.toLowerCase().contains(q);
            }).toList();
    });
  }

  bool _livroJaAdicionado(Livro livro) {
    return widget.estante.any((l) => l.id == livro.id);
  }

  void adicionarComCategoria(Livro livro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
          children: ['Quero Ler', 'Lendo', 'Lido'].map((categoria) {
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
                onPressed: () {
                  setState(() {
                    final novoLivro = Livro(
                      id: livro.id,
                      titulo: livro.titulo,
                      autor: livro.autor,
                      descricao: livro.descricao,
                      imagemAsset: livro.imagemAsset,
                      categoria: categoria,
                    );
                    widget.estante.add(novoLivro);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Livro adicionado à categoria $categoria'),
                      backgroundColor: const Color(0xFFB87333),
                    ),
                  );
                },
                child: Text(categoria),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Função para navegar para a tela de detalhes
  void _navegarParaDetalhes(Livro livro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(
          livro: livro,
          estante: widget.estante,
          onAdicionarLivro: (livro, categoria) {
            setState(() {
              final novoLivro = Livro(
                id: livro.id,
                titulo: livro.titulo,
                autor: livro.autor,
                descricao: livro.descricao,
                imagemAsset: livro.imagemAsset,
                categoria: categoria,
              );
              widget.estante.add(novoLivro);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      body: Column(
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
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredLivros.isEmpty
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
                      final jaAdicionado = _livroJaAdicionado(livro);
                      return GestureDetector(
                        onTap: () => _navegarParaDetalhes(livro), // Clique no container inteiro
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
                                  width: 80,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
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
                                    GestureDetector(
                                      onTap: () {
                                        // Previne que o clique no botão acione também o clique do container
                                      },
                                      child: SizedBox(
                                        width: 250,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: jaAdicionado
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFFBF6E3F),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                          ),
                                          onPressed: jaAdicionado
                                              ? null
                                              : () => adicionarComCategoria(livro),
                                          icon: Icon(
                                            jaAdicionado
                                                ? Icons.check_circle
                                                : Icons.book,
                                            size: 20,
                                          ),
                                          label: Text(
                                            jaAdicionado
                                                ? 'Adicionado à Estante'
                                                : 'Adicionar Livro',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
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