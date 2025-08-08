import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _carregando = false;

  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _carregando = true);
    try {
      // cria usuário
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      // opcional: grava displayName
      await cred.user?.updateDisplayName(nome);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Color(0xFFB87333),
          duration: Duration(seconds: 1),
        ),
      );

      // redireciona para a tela principal
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/app');
      });
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao criar conta';
      if (e.code == 'email-already-in-use') {
        msg = 'E-mail já cadastrado';
      } else if (e.code == 'invalid-email') {
        msg = 'E-mail inválido';
      } else if (e.code == 'weak-password') {
        msg = 'Senha muito fraca';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
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
              Image.asset('assets/imagens/logo.png', width: 150, height: 150),
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

              // Nome
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

              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _cadastrar,
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
                          'Cadastrar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Link login
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
    );
  }
}
