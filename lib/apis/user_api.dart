import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDBProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(User user);
}

class UserAPI implements IUserAPI {
  final Databases _db;

  UserAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(User user) async {
    try {
      final doc = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: ID.unique(),
          data: user.toMap());

      // ignore: avoid_print
      print('Save User Successfully $doc');
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failuer(e.message ?? 'Some unexpected error occured...', st),
      );
    } catch (e, st) {
      return left(
        Failuer(e.toString(), st),
      );
    }
  }
}
