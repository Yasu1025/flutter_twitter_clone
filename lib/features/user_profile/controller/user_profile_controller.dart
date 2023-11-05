import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(ref.watch(tweetAPIProvider));
});

final getUserTweetsProvider = FutureProvider.family((ref, String uid) {
  final exploreController = ref.watch(userProfileControllerProvider.notifier);
  return exploreController.getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  UserProfileController(this._tweetAPI) : super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
}
