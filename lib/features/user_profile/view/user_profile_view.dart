import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/models/user_model.dart';

class UserProfileView extends StatelessWidget {
  static route(User user) => MaterialPageRoute(
        builder: (context) => UserProfileView(user: user),
      );
  final User user;
  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfile(user),
    );
  }
}
