import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha e-mail e senha')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      // Login bem-sucedido, vai pra rota '/app'
      Navigator.pushReplacementNamed(context, '/app');
    } on FirebaseAuthException catch (e) {
      String msg;
      if (e.code == 'user-not-found') {
        msg = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        msg = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        msg = 'E-mail inválido';
      } else {
        msg = 'Erro ao fazer login';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro desconhecido')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const corBorda = Color(0xFFBF6E3F);
    const corFundo = Color(0xFFE6E0D8);

    return Scaffold(
      backgroundColor: corFundo,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/imagens/logo.png', width: 150, height: 150),
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

              // E-mail
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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

              // Senha
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
                  onPressed: _carregando ? null : _fazerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBF6E3F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _carregando
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white))
                      : const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    );
  }
}
