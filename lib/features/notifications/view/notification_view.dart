import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/features/notifications/widget/notification_tile.dart';
import 'package:twitter_clone/models/notification_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Text('Something went wrong..')
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(AppWriteConstants
                              .notificationColletionCreatePath)) {
                            final latestNotice =
                                NotificationModel.fromMap(data.payload);
                            if (latestNotice.uid == currentUser.uid) {
                              notifications.insert(0, latestNotice);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (BuildContext context, int index) {
                                final notification = notifications[index];
                                return NotificationTile(
                                  notification: notification,
                                );
                              },
                            ),
                          );
                        },
                        error: (error, st) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
