import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final userAPI = ref.watch(userAPIProvider);
  return AuthController(authAPI, userAPI);
});

// user details by UID
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// CurrentUser Details
final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController(this._authAPI, this._userAPI) : super(false);
  // state = isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

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
          uid: r.$id,
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

  Future<User> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = User.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold(
      (l) => null,
      (r) {
        Navigator.pushAndRemoveUntil(
          context,
          SignUpView.route(),
          (route) => false,
        );
      },
    );
  }
}
