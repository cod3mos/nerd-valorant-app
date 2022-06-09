import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? googleUser;
  bool isLoading = true;

  GoogleSignInProvider() {
    _googleCheck();
  }

  _googleCheck() {
    _auth.authStateChanges().listen((User? user) {
      googleUser = (user == null) ? null : user;
      isLoading = false;

      notifyListeners();
    });
  }

  googleLogin() async {
    try {
      final authenticatedUser = await _googleSignIn.signIn();

      if (authenticatedUser != null) {
        final googleAuth = await authenticatedUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        googleUser = userCredential.user;

        notifyListeners();
      }

      return googleUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw AuthException('Credencial inválida');
      } else if (e.code == 'user-disabled') {
        throw AuthException('Sua conta foi desativada por um administrador');
      }
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        throw AuthException('Sem conexão com a internet');
      }
    }
  }

  Future logoutOfAllAccounts() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);

    googleUser = null;

    notifyListeners();
  }
}
