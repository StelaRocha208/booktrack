import 'package:flutter/material.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const corBorda = Color(0xFFBF6E3F); 
    const corFundo = Color(0xFFE6E0D8); 

    return Container(
      color: corFundo,
      child: Scaffold(
        backgroundColor: corFundo,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/imagens/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 30),

                const Text(
                  'BookTrack',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA65638),
                  ),
                ),
                const SizedBox(height: 40),

                // Campo de e-mail
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corBorda, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corBorda, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo de senha
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corBorda, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corBorda, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão de login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/app');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF6E3F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Link para cadastro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CadastroScreen()),
                    );
                  },
                  child: const Text(
                    'Não tem conta? Cadastre-se',
                    style: TextStyle(color: Color(0xFF8B4513)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



