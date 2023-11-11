import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(User user) => MaterialPageRoute(
        builder: (context) => UserProfileView(user: user),
      );
  final User user;
  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User copiedUser = user;
    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
          data: (data) {
            if (data.events.contains(
              AppWriteConstants.userCollectionUpdatePath(copiedUser.uid),
            )) {
              copiedUser = User.fromMap(data.payload);
            }
            return UserProfile(copiedUser);
          },
          error: (error, st) => ErrorText(
                error: error.toString(),
              ),
          loading: () {
            return UserProfile(copiedUser);
          }),
    );
  }
}
