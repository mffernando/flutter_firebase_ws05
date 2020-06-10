import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BaseAuth with ChangeNotifier {
  String errorMessage = '';

  //retornar o usuario
  Future<FirebaseUser> getUser() {
    return FirebaseAuth.instance.currentUser();
  }

  //fazer login com e-mail e senha
  Future<bool> loginUser({String email, String password}) async {
    String errorMessage;
    try {
      //valida e-mail e senha
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (error) {
      handleError(error);
      return false;
    }
  }

  //validacoes
  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
  }
}
