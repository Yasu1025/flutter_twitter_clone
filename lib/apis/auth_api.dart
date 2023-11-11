import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';

// to signup(with appwrite), get user account => Account
// To access user related data => model.User

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  Future<model.User?> currentUserAccount();
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  });
  FutureEither<model.Session> login({
    required String email,
    required String password,
  });
  FutureEitherVoid logout();
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failuer(e.message ?? '', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failuer(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEither<model.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );

      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failuer(e.message ?? '', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failuer(e.toString(), stackTrace),
      );
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failuer(e.message ?? '', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failuer(e.toString(), stackTrace),
      );
    }
  }
}
