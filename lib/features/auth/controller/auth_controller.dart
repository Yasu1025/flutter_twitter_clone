import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI, userAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController(this._authAPI, this._userAPI) : super(false);
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
      (r) async {
        User user = User(
          uid: '',
          name: getNameFromEmail(email),
          email: email,
          profilePic: '',
          banerPic: '',
          bio: '',
          followers: const [],
          followings: const [],
          isTwitterBlue: false,
        );

        final userRes = await _userAPI.saveUserData(user);
        userRes.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, 'Account has been created!!! Please login!!');
            Navigator.push(context, LoginView.route());
          },
        );
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
