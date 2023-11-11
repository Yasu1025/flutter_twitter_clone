import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return NotificationController(notificationAPI);
});

final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationCtrl = ref.watch(notificationControllerProvider.notifier);
  return notificationCtrl.getNotifications(uid);
});

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController(this._notificationAPI) : super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = NotificationModel(
      text: text,
      postId: postId,
      id: '', // appwrite automatically generate
      uid: uid,
      notificationType: notificationType,
    );

    await _notificationAPI.createNotification(notification);
  }

  Future<List<NotificationModel>> getNotifications(String uid) async {
    final notificationList = await _notificationAPI.getNotifications(uid);
    return notificationList
        .map((notification) => NotificationModel.fromMap(notification.data))
        .toList();
  }
}
