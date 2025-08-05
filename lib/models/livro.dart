class Livro {
  final String id;
  final String titulo;
  final String autor;
  final String descricao;
  final String imagemAsset;
  String categoria;
  String? resenha;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.descricao,
    required this.imagemAsset,
    this.categoria = '',
    this.resenha,
  });
}
