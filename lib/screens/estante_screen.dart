import 'package:flutter/material.dart';
import '../models/livro.dart';
import 'detalhes_screen.dart'; // Importe a tela de detalhes
import 'resenha_screen.dart'; // Import para abrir diretamente a tela de resenha

class EstanteScreen extends StatefulWidget {
  final List<Livro> estante;

  const EstanteScreen({super.key, required this.estante});

  @override
  State<EstanteScreen> createState() => _EstanteScreenState();
}

class _EstanteScreenState extends State<EstanteScreen> {
  
  // Função para navegar para a tela de detalhes
  void _navegarParaDetalhes(Livro livro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesScreen(
          livro: livro,
          estante: widget.estante,
          onAdicionarLivro: (livro, categoria) {
            // Como o livro já está na estante, esta função não será usada
            // mas é necessária para manter a interface consistente
          },
        ),
      ),
    ).then((_) {
      setState(() {}); // atualiza caso algo tenha mudado nos detalhes
    });
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Quero Ler', 'Lendo', 'Lido'];

    return DefaultTabController(
      length: categorias.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F0),
        body: Column(
          children: [
            // Header customizado igual ao catálogo
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(color: Color(0xFFA65638)),
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
            
            // TabBar customizada
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFA65638),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                tabs: categorias.map((c) => Tab(text: c)).toList(),
              ),
            ),
            
            Expanded(
              child: TabBarView(
                children: categorias.map((categoria) {
                  final livrosCategoria =
                      widget.estante.where((l) => l.categoria == categoria).toList();
                  
                  return livrosCategoria.isEmpty
                      ? Center(
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
                                'Nenhum livro em "$categoria"',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF8B4513),
                                  fontWeight: FontWeight.w500,
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
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: livrosCategoria.length,
                          itemBuilder: (_, index) {
                            final livro = livrosCategoria[index];
                            return GestureDetector(
                              onTap: () => _navegarParaDetalhes(livro),
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
                                        width: 96,  // Aumentado
                                        height: 120, // Aumentado
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
                                    
                                    // Informações do livro
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

                                          // Botão "Adicionar resenha" exibido apenas para livros marcados como "Lido"
                                          if (livro.categoria == 'Lido') ...[
                                            SizedBox(
                                              width: 160,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => ResenhaScreen(livro: livro),
                                                    ),
                                                  ).then((_) {
                                                    setState(() {});
                                                  });
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
                                        ],
                                      ),
                                    ),
                                    
                                    GestureDetector(
                                      onTap: () {},
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Color(0xFF8B4513),
                                        ),
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'mover',
                                            child: Row(
                                              children: [
                                                Icon(Icons.swap_horiz, size: 18),
                                                SizedBox(width: 8),
                                                Text('Mover categoria'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'remover',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, size: 18),
                                                SizedBox(width: 8),
                                                Text('Remover'),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'remover') {
                                            _removerLivro(context, livro);
                                          } else if (value == 'mover') {
                                            _moverLivro(context, livro);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removerLivro(BuildContext context, Livro livro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2F2F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          'Remover Livro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        content: Text(
          'Deseja remover "${livro.titulo}" da sua estante?',
          style: const TextStyle(color: Color(0xFF333333)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBF6E3F),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                widget.estante.remove(livro);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro removido da estante'),
                  backgroundColor: Color(0xFFB87333),
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _moverLivro(BuildContext context, Livro livro) {
    final categorias = ['Quero Ler', 'Lendo', 'Lido'];
    final categoriasDisponiveis = categorias
        .where((c) => c != livro.categoria)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2F2F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Center(
          child: Text(
            'Mover para categoria',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categoriasDisponiveis.map((categoria) {
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
                    livro.categoria = categoria;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Livro movido para $categoria'),
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
}


