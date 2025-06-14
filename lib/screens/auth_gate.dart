// auth_gate.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../controllers/decision_controller.dart';
import 'login_page.dart';
import '../pain.dart'; // Importe sua tela principal existente

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Usuário logado
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginPage();
          } else {
            // Quando autenticado, marcar como premium e mostrar sua tela principal
            final controller = Provider.of<DecisionController>(
              context,
              listen: false,
            );
            controller.autenticarComoPremium();
            return Paginas();
          }
        }

        // Carregando
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
