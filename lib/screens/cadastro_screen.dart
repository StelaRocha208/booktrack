import 'package:flutter/material.dart';
import 'login_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
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
                  'Criar Conta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA65638),
                  ),
                ),
                const SizedBox(height: 40),

                // Campo nome
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
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

                // Campo e-mail
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

                // Campo senha
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

                // Botão de cadastro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Mostra mensagem de sucesso
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Conta criada'),
                          backgroundColor: Color(0xFFB87333),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      // Redireciona após a mensagem
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pushReplacementNamed(context, '/app');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF6E3F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Link para login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Já tem conta? Entrar',
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
