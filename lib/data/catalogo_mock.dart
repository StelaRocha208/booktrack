import '../models/livro.dart';

final List<Livro> catalogoLivros = [
  Livro(
    id: '1',
    titulo: 'Dom Casmurro',
    autor: 'Machado de Assis',
    descricao: 'Um clássico da literatura brasileira.',
    imagemAsset: 'assets/imagens/dom_casmurro.png',
  ),
  Livro(
    id: '2',
    titulo: '1984',
    autor: 'George Orwell',
    descricao: 'Uma distopia sobre vigilância e liberdade.',
    imagemAsset: 'assets/imagens/1984.png',
  ),
  Livro(
    id: '3',
    titulo: 'O Pequeno Príncipe',
    autor: 'Antoine de Saint-Exupéry',
    descricao: 'Uma fábula poética sobre a infância e o amor.',
    imagemAsset: 'assets/imagens/pequeno_principe.png',
  ),
];
