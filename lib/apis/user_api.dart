import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDBProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return UserAPI(db: db, realtime: realtime);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(User user);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(User user);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(User user);
  FutureEitherVoid addToFolloing(User user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(User user) async {
    try {
      final doc = await _db.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: user.uid,
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

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.usersCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final doc = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.usersCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return doc.documents;
  }

  @override
  FutureEitherVoid updateUserData(User user) async {
    try {
      final doc = await _db.updateDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.usersCollection,
          documentId: user.uid,
          data: user.toMap());

      // ignore: avoid_print
      print('Update User Successfully $doc');
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

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      AppWriteConstants.userCollectionPath,
    ]).stream;
  }

  @override
  FutureEitherVoid followUser(User user) async {
    try {
      final doc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        documentId: user.uid,
        data: {'followers': user.followers},
      );

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

  @override
  FutureEitherVoid addToFolloing(User user) async {
    try {
      final doc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollection,
        documentId: user.uid,
        data: {'followings': user.followings},
      );

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
