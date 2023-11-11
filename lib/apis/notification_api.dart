import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDBProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return NotificationAPI(db: db, realtime: realtime);
});

abstract class INotifivation {
  FutureEitherVoid createNotification(NotificationModel notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationAPI implements INotifivation {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid createNotification(NotificationModel notification) async {
    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
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
  Future<List<Document>> getNotifications(String uid) async {
    final docs = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.notificationCollection,
        queries: [Query.equal('uid', uid)]);

    return docs.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe(
      [AppWriteConstants.notificationColletionPath],
    ).stream;
  }
}
