import 'package:decisionmaker/pages/login_page.dart';
import 'package:decisionmaker/pain.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/decision_controller.dart';
import 'controllers/tutorial_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  print("já");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DecisionController()),
        ChangeNotifierProvider(create: (_) => TutorialProvider()),
      ],
      child: const DecisionMakerApp(),
    ),
  );
}

class DecisionMakerApp extends StatelessWidget {
  const DecisionMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decision Maker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthGate(),
      routes: { // Rota principal
        '/principal': (context) => Paginas(),
        '/paginaUsuario': (context) => const PaginaUsuario(),
        '/login': (context) => const LoginPage(),
        // Outras rotas...
      },
    );
  }
}
