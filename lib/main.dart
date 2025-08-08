import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/catalogo_screen.dart';
import 'screens/estante_screen.dart';
import 'models/livro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyRootApp());
}

class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Inicia na tela de login
      home: const LoginScreen(),
      routes: {
        // rota que abre o app principal (BookTrackApp)
        '/app': (context) => const BookTrackApp(),
      },
    );
  }
}

class BookTrackApp extends StatefulWidget {
  const BookTrackApp({super.key});

  @override
  State<BookTrackApp> createState() => _BookTrackAppState();
}

class _BookTrackAppState extends State<BookTrackApp> {
  final List<Livro> estante = [];
  int paginaAtual = 0;

  // Versões outlined e filled de cada ícone (apenas Catálogo e Home)
  final _iconsOutlined = [Icons.menu_book_outlined, Icons.home_outlined];
  final _iconsFilled = [Icons.menu_book, Icons.home];

  @override
  Widget build(BuildContext context) {
    final telas = [
      CatalogoScreen(estante: estante),
      EstanteScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: telas[paginaAtual],
        bottomNavigationBar: _buildCustomBottomNav(),
      ),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_iconsOutlined.length, (i) {
          final isActive = paginaAtual == i;
          return GestureDetector(
            onTap: () => setState(() => paginaAtual = i),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                isActive ? _iconsFilled[i] : _iconsOutlined[i],
                size: 32,
                color:
                    isActive
                        ? const Color(0xFFBF6E3F) // cor ativa
                        : const Color(0xFF260F01), // cor inativa
              ),
            ),
          );
        }),
      ),
    );
  }
}
