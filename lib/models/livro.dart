class Livro {
  final String id;
  final String titulo;
  final String autor;
  final String descricao;
  final String imagemAsset; // caminho exato, ex: "assets/imagens/1984.png"
  String categoria;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.descricao,
    required this.imagemAsset,
    this.categoria = '',
  });
}
