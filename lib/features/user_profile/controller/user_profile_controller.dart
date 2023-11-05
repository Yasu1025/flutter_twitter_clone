import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/core/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    ref.watch(tweetAPIProvider),
    ref.watch(userAPIProvider),
    ref.watch(storageAPIProvider),
  );
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) {
  final exploreController = ref.watch(userProfileControllerProvider.notifier);
  return exploreController.getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final UserAPI _userAPI;
  final StorageAPi _storageAPi;
  UserProfileController(
    this._tweetAPI,
    this._userAPI,
    this._storageAPi,
  ) : super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void updateUserProfile({
    required User user,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPi.uploadImages([bannerFile]);
      user = user.copyWith(
        banerPic: bannerUrl[0],
      );
    }
    if (profileFile != null) {
      final profileUrl = await _storageAPi.uploadImages([profileFile]);
      user = user.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.pop(context);
      },
    );
  }
}
