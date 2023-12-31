import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final tweetControllerNotifierProvider =
    StateNotifierProvider<TweetControllerNotifier, bool>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  final notificationCtrl = ref.watch(notificationControllerProvider.notifier);
  final storageAPI = ref.watch(storageAPIProvider);
  return TweetControllerNotifier(
    ref,
    tweetAPI,
    notificationCtrl,
    storageAPI,
  );
});

final getTweetProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerNotifierProvider.notifier);
  return tweetController.getTweets();
});

final getRepliedTweetProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerNotifierProvider.notifier);
  return tweetController.getRepliedToTweet(tweet);
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerNotifierProvider.notifier);
  return tweetController.getTweetById(id);
});

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetControllerNotifier extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final NotificationController _notificationCtrl;
  final StorageAPi _storageAPI;
  final Ref _ref;
  TweetControllerNotifier(
      this._ref, this._tweetAPI, this._notificationCtrl, this._storageAPI)
      : super(false);
  // state is isLoading

// Privates ----------------
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImages(images);
    Tweet tweet = Tweet(
      id: '',
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      reshareCount: 0,
      resharedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationCtrl.createNotification(
            text: '${user.name} Replied to your tweet!!',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
          );
        }
        Navigator.push(context, HomeView.route());
      },
    );
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    print(DateTime.now());
    Tweet tweet = Tweet(
      id: '',
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      reshareCount: 0,
      resharedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (repliedToUserId.isNotEmpty) {
          _notificationCtrl.createNotification(
            text: '${user.name} Replied to your tweet!!',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
          );
        }
        Navigator.push(context, HomeView.route());
      },
    );
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (var word in wordsInSentence) {
      if (word.startsWith('http://') ||
          word.startsWith('https://') ||
          word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (var word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getRepliedToTweet(Tweet tweet) async {
    final tweetList = await _tweetAPI.getRepliedToTweet(tweet);
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Text.....');
      return;
    }

    if (images.isNotEmpty) {
      // tweet with images
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      // tweet just text
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  void likeTweet(Tweet tweet, User user) async {
    List<String> likes = tweet.likes;
    bool isToLike = false;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
      isToLike = true;
    }

    tweet = tweet.copyWith(likes: likes);

    final res = await _tweetAPI.likeTweet(tweet);
    res.fold(
      (l) => null,
      (r) {
        if (isToLike) {
          _notificationCtrl.createNotification(
            text: '${user.name} liked your tweet!!',
            postId: tweet.id,
            notificationType: NotificationType.like,
            uid: tweet.uid,
          );
        }
      },
    );
  }

  void reshareTweet(
    Tweet tweet,
    User currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      resharedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
    );

    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        tweet = tweet.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationCtrl.createNotification(
              text: '${currentUser.name} retweeted your tweet!!',
              postId: tweet.id,
              notificationType: NotificationType.retweet,
              uid: tweet.uid,
            );
            showSnackBar(context, 'Retweeted!!');
          },
        );
      },
    );
  }
}
