import 'package:flutter/material.dart';
import '../models/livro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResenhaScreen extends StatefulWidget {
  final Livro livro;

  const ResenhaScreen({super.key, required this.livro});

  @override
  State<ResenhaScreen> createState() => _ResenhaScreenState();
}

class _ResenhaScreenState extends State<ResenhaScreen> {
  late TextEditingController _resenhaController;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late final CollectionReference<Map<String, dynamic>> _resenhaRef;

  @override
  void initState() {
    super.initState();
    _resenhaController = TextEditingController(text: widget.livro.resenha ?? '');

    // users/{uid}/resenhas/{id_livro}
    _resenhaRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('resenhas');
  }

  @override
  void dispose() {
    _resenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvarResenha() async {
    final texto = _resenhaController.text.trim();

    await _resenhaRef.doc(widget.livro.id).set({
      'idLivro': widget.livro.id,
      'tituloLivro': widget.livro.titulo,
      'autorLivro': widget.livro.autor,
      'imagemAsset': widget.livro.imagemAsset,
      'resenha': texto,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      widget.livro.resenha = texto;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resenha salva com sucesso!'),
        backgroundColor: Color(0xFFB87333),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const corAutor = Color(0xFF8B4513);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      // resizeToAvoidBottomInset garante que o layout se ajuste quando o teclado aparece
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header customizado para manter consistência com as outras telas
            Container(
              width: double.infinity,
              height: 100,
              color: const Color(0xFFA65638),
              child: Stack(
                children: [
                  // Botão de voltar customizado
                  Positioned(
                    left: 16,
                    top: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  // Título
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Resenha',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Conteúdo principal em SingleChildScrollView para evitar overflow
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.livro.imagemAsset,
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 160,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.book, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.livro.titulo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'por ${widget.livro.autor}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: corAutor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // TextField com altura fixa mínima para não colapsar com o teclado
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4, // 40% da altura da tela
                      child: TextField(
                        controller: _resenhaController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Digite sua resenha aqui...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: corAutor, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: corAutor, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: corAutor, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBF6E3F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _salvarResenha,
                        child: const Text(
                          'Salvar Resenha',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Espaço extra para garantir que o botão não fique colado no final
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}