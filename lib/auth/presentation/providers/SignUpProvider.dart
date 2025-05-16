import 'package:alquilafacil/auth/shared/AuthFilter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../../data/remote/helpers/auth_service_helper.dart';

class SignUpProvider extends ChangeNotifier with AuthFilter {
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String successFulMessage = "";
  final logger = Logger();
  final AuthServiceHelper serviceHelper;
  SignUpProvider(this.serviceHelper);


  @override
  String? validateEmail() {
    if (email.isEmpty) {
      return "El email es requerido";
    }
    if (!email.contains('@')) {
      return "Por favor, ingrese un email valido";
    }
    return null;
  }

  @override
  String? validatePassword() {
    if (password.isEmpty) {
      return "Por favor ingrese una contraseña valida";
    }
    if (password.length < 8) {
      return "La contraseña debe tener como minimo 8 caracteres";
    }
    if(password == "12345678"){
      return "La contraseña no puede ser 12345678";
    }
    return null;
  }


  String? validateConfirmPassword() {
    if (confirmPassword != password) {
      return 'Las contraseñas no coinciden';
    }
    if (confirmPassword.isEmpty) {
      return "Por favor ingrese una contraseña valida";
    }
    if (confirmPassword.length < 8) {
      return "La contraseña debe tener como minimo 8 caracteres";
    }
    if(confirmPassword == "12345678"){
      return "La contraseña no puede ser 12345678";
    }
    return null;
  }

  String? validateUsername(){
    if(username.isEmpty){
      return "Por favor ingrese un nombre de usuario";
    }
    return null;
  }

  void setEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void setPassword(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

  void setUsername(String newUsername){
    username = newUsername;
    notifyListeners();
  }

  void setSuccessfulMessage(String messageResponse){
    successFulMessage = messageResponse;
    notifyListeners();
  }

  void setConfirmPassword(String newConfirmPassword) {
    confirmPassword = newConfirmPassword;
    notifyListeners();
  }

  Future signUp() async {
    var message = await serviceHelper.signUp(username, password, email);
    setSuccessfulMessage(message);
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("Google sign-in failed");
    }
    final GoogleSignInAuthentication? authentication = await googleUser.authentication;
    if (authentication == null) {
      throw Exception("Failed to get authentication credentials from Google");
    }

    final credentials = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);
    return userCredential;
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken!.tokenString);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential;
      } else {
        throw Exception("Sign in with facebook was failed: ${result.status}");
      }
    } catch (e) {
      logger.e("Error while trying to sign in with facebook: $e");
      rethrow;
    }
  }

}
