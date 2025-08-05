import 'package:flutter/material.dart';
import '../models/livro.dart';
import 'resenha_screen.dart'; // lembre-se de importar a tela da resenha

class DetalhesScreen extends StatefulWidget {
  final Livro livro;
  final List<Livro> estante;
  final Function(Livro, String) onAdicionarLivro;

  const DetalhesScreen({
    super.key,
    required this.livro,
    required this.estante,
    required this.onAdicionarLivro,
  });

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  // retorna o livro que está na estante (ou null se não existir)
  Livro? _livroNaEstante() {
    try {
      return widget.estante.firstWhere((l) => l.id == widget.livro.id);
    } catch (_) {
      return null;
    }
  }

  bool _livroJaAdicionado() {
    return _livroNaEstante() != null;
  }

  bool _livroEstaLido() {
    final l = _livroNaEstante();
    return l != null && l.categoria == 'Lido';
  }

  void _adicionarComCategoria(BuildContext context) {
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
                  widget.onAdicionarLivro(widget.livro, categoria);
                  Navigator.pop(context);
                  Navigator.pop(context); // Volta para a tela anterior
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

  @override
  Widget build(BuildContext context) {
    final jaAdicionado = _livroJaAdicionado();
    final estaLido = _livroEstaLido();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      body: Column(
        children: [
          // Header com mesmo estilo do catálogo
          Container(
            width: double.infinity,
            height: 100,
            color: const Color(0xFFA65638),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Detalhes do Livro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Conteúdo principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagem do livro
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.livro.imagemAsset,
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 150,
                          height: 200,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.book,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Título do livro
                    Text(
                      widget.livro.titulo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Autor
                    Text(
                      'por ${widget.livro.autor}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8B4513),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Descrição
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sinopse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.livro.descricao,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    
                    // Botão de ação "Adicionar à Estante"
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jaAdicionado
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFBF6E3F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: jaAdicionado
                            ? null
                            : () => _adicionarComCategoria(context),
                        icon: Icon(
                          jaAdicionado
                              ? Icons.check_circle
                              : Icons.bookmark_add,
                          size: 24,
                        ),
                        label: Text(
                          jaAdicionado
                              ? 'Já está na sua estante'
                              : 'Adicionar à Estante',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Mensagem "já está na sua estante" e depois a resenha (se houver)
                    if (jaAdicionado) const SizedBox(height: 12),

                    if (jaAdicionado) ...[
                      Text(
                        'Este livro já foi adicionado à sua estante',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),
                      
                      // Exibir resenha (após a mensagem e antes do botão de resenha)
                      if (widget.livro.resenha != null && widget.livro.resenha!.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sua Resenha',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.livro.resenha!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ],

                    // Botão "Adicionar/Editar Resenha" só aparece se o livro já está na estante e marcado como Lido
                    if (jaAdicionado && estaLido)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResenhaScreen(livro: widget.livro),
                              ),
                            ).then((_) {
                              setState(() {}); // Atualiza após salvar/editar resenha
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBF6E3F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text('Adicionar/Editar Resenha'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
