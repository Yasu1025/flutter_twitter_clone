import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widget/card/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TweetActionButtons extends ConsumerWidget {
  final Tweet tweet;
  final User user;

  const TweetActionButtons({
    super.key,
    required this.tweet,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetIconButton(
            pathName: AssetsConstants.viewsIcon,
            text: (tweet.commentIds.length +
                    tweet.reshareCount +
                    tweet.likes.length)
                .toString(),
            onTap: () {},
          ),
          TweetIconButton(
            pathName: AssetsConstants.commentIcon,
            text: (tweet.commentIds.length).toString(),
            onTap: () {},
          ),
          TweetIconButton(
            pathName: AssetsConstants.retweetIcon,
            text: (tweet.reshareCount).toString(),
            onTap: () {},
          ),
          LikeButton(
            onTap: (isLiked) async {
              ref
                  .read(tweetControllerNotifierProvider.notifier)
                  .likeTweet(tweet, user);
              return !isLiked;
            },
            size: 25,
            isLiked: tweet.likes.contains(user.uid),
            likeBuilder: (isLiked) {
              return isLiked
                  ? SvgPicture.asset(
                      AssetsConstants.likeFilledIcon,
                      color: Pallete.redColor,
                    )
                  : SvgPicture.asset(
                      AssetsConstants.likeOutlinedIcon,
                      color: Pallete.greyColor,
                    );
            },
            likeCount: tweet.likes.length,
            countBuilder: (likeCount, isLiked, text) {
              return Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isLiked ? Pallete.redColor : Pallete.greyColor,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              size: 25,
              color: Pallete.greyColor,
            ),
          )
        ],
      ),
    );
  }
}
