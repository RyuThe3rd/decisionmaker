import 'package:flutter/material.dart';
import '../pain.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String mensagem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService.signInWithEmail(
                  emailController.text,
                  senhaController.text,
                );
                if (result == null) {
                  print('algo');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                }

              },
              child: const Text('Entrar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService.signInWithGoogle();
                setState(() {
                  mensagem = result ?? 'Login com Google realizado!';
                });
              },
              child: const Text('Entrar com Google'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('Não tem conta? Cadastre-se'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: const Text('Esqueceu a senha?'),
            ),
            const SizedBox(height: 16),
            if (mensagem.isNotEmpty) Text(mensagem),
          ],
        ),
      ),
    );
  }
}
