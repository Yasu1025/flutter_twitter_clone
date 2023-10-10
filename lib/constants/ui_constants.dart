// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
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

// TODO: create views
  static List<Widget> bottomTabBarPages = [
    const Text('Feed screen'),
    const Text('Search screen'),
    const Text('Notifications screen'),
  ];
}
