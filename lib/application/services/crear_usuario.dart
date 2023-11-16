import 'package:firebase_auth/firebase_auth.dart';

class CrearUsuario {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      return user;
    } catch (e) {
      print('Error al crear usuario: $e');
      return null;
    }
  }
}
