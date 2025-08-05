import 'package:flutter/material.dart';
import '../models/livro.dart';

class ResenhaScreen extends StatefulWidget {
  final Livro livro;

  const ResenhaScreen({super.key, required this.livro});

  @override
  State<ResenhaScreen> createState() => _ResenhaScreenState();
}

class _ResenhaScreenState extends State<ResenhaScreen> {
  late TextEditingController _resenhaController;

  @override
  void initState() {
    super.initState();
    _resenhaController = TextEditingController(text: widget.livro.resenha ?? '');
  }

  @override
  void dispose() {
    _resenhaController.dispose();
    super.dispose();
  }

  void _salvarResenha() {
    setState(() {
      widget.livro.resenha = _resenhaController.text;
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
      appBar: AppBar(
        title: const Text(
          'Resenha',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFA65638),
      ),
      backgroundColor: const Color(0xFFF2F2F0),
      body: Padding(
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
                  child: const Icon(
                    Icons.book,
                    size: 40,
                    color: Colors.grey,
                  ),
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

            Expanded(
              child: TextField(
                controller: _resenhaController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Digite aqui...',
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
                ),
                onPressed: _salvarResenha,
                child: const Text('Salvar Resenha'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

