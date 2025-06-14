import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pain.dart';
import 'home_page.dart';
import 'login_page.dart';

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
            //return const HomePage();
            return Paginas();
          }
        }

        // Carregando
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
