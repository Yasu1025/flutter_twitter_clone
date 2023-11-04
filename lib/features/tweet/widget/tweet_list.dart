import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widget/card/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetProvider).when(
          data: (tweets) {
            // stream
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events
                        .contains(AppWriteConstants.tweetColletionCreatePath)) {
                      if (tweets[0].tweetedAt !=
                          Tweet.fromMap(data.payload).tweetedAt) {
                        tweets.insert(
                          0,
                          Tweet.fromMap(data.payload),
                        );
                      }
                    } else if (data.events
                        .contains(AppWriteConstants.tweetColletionUpdatePath)) {
                      // get id of original tweet
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final tweetId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var tweet = tweets
                          .where((element) => element.id == tweetId)
                          .first;

                      final tweetIndex = tweets.indexOf(tweet);
                      tweets.removeWhere((element) => element.id == tweetId);

                      tweet = Tweet.fromMap(data.payload);
                      tweets.insert(tweetIndex, tweet);
                    }

                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet);
                      },
                    );
                  },
                );
          },
          error: (error, st) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
