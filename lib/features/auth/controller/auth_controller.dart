import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController(this._authAPI) : super(false);
  // state = isLoading

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    res.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        showSnackBar(context, 'Account has been created!!! Please login!!');
        Navigator.push(context, LoginView.route());
      },
    );
    state = false;
  }

  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    res.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
    state = false;
  }
}
