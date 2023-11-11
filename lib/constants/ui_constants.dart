import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/explore/view/explore_view.dart';
import 'package:twitter_clone/features/notifications/view/notification_view.dart';
import 'package:twitter_clone/features/tweet/widget/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const ExploreView(),
    const NotificationView(),
  ];
}
