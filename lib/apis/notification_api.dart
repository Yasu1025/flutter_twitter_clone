import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/notification_model.dart';

final notificationAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDBProvider);
  return NotificationAPI(db: db);
});

abstract class INotifivation {
  FutureEitherVoid createNotification(NotificationModel notification);
}

class NotificationAPI implements INotifivation {
  final Databases _db;

  NotificationAPI({required Databases db}) : _db = db;

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
}
