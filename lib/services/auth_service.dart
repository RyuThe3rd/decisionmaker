import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //Login com email e senha
  static Future<String?> signInWithEmail(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro ao fazer login.';
    }
  }

  // Cadastro com email e senha
  static Future<String?> registerWithEmail(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro ao cadastrar.';
    }
  }

  // Recuperar senha
  static Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Verifique seu email para redefinir a senha.';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro ao enviar email de redefinição.';
    }
  }

  // Login com Google
  static Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return 'Login cancelado pelo usuário.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erro no login com Google.';
    } catch (e) {
      return 'Erro inesperado no login com Google.';
    }
  }

  // Logout
  static Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Obter usuário logado
  static User? get currentUser => _auth.currentUser;
}
