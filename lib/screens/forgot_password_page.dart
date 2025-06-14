import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  String mensagem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await AuthService.resetPassword(
                  emailController.text,
                );
                setState(() {
                  mensagem =
                      result ?? 'Verifique seu email para redefinir a senha.';
                });
              },
              child: const Text('Enviar email de recuperação'),
            ),
            const SizedBox(height: 16),
            if (mensagem.isNotEmpty) Text(mensagem),
          ],
        ),
      ),
    );
  }
}