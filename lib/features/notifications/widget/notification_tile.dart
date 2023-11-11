import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingIcon =
        notification.notificationType == NotificationType.follow
            ? const Icon(
                Icons.person,
                color: Pallete.blueColor,
              )
            : notification.notificationType == NotificationType.like
                ? SvgPicture.asset(
                    AssetsConstants.likeFilledIcon,
                    color: Pallete.redColor,
                    height: 20,
                  )
                : notification.notificationType == NotificationType.retweet
                    ? SvgPicture.asset(
                        AssetsConstants.retweetIcon,
                        color: Pallete.whiteColor,
                        height: 20,
                      )
                    : const Icon(
                        Icons.comment,
                        color: Pallete.whiteColor,
                      );

    return ListTile(
      leading: leadingIcon,
      title: Text(
        notification.text,
      ),
    );
  }
}
