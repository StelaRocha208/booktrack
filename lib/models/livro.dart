class Livro {
  final String id;
  final String titulo;
  final String autor;
  final String descricao;
  final String imagemAsset; // Caminho da imagem local no assets/
  String categoria; // 'Quero Ler', 'Lendo', 'Lido'

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.descricao,
    required this.imagemAsset,
    this.categoria = '',
  });
}
