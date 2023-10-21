import 'package:flutter/material.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/features/tweet/widget/card/tweet_icon_button.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TweetActionButtons extends StatelessWidget {
  final List<String> commentIds;
  final int reshareCount;
  final List<String> likes;
  const TweetActionButtons({
    super.key,
    required this.commentIds,
    required this.reshareCount,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetIconButton(
            pathName: AssetsConstants.viewsIcon,
            text: (commentIds.length + reshareCount + likes.length).toString(),
            onTap: () {},
          ),
          TweetIconButton(
            pathName: AssetsConstants.commentIcon,
            text: (commentIds.length).toString(),
            onTap: () {},
          ),
          TweetIconButton(
            pathName: AssetsConstants.retweetIcon,
            text: (reshareCount).toString(),
            onTap: () {},
          ),
          TweetIconButton(
            pathName: AssetsConstants.likeOutlinedIcon,
            text: (likes.length).toString(),
            onTap: () {},
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
