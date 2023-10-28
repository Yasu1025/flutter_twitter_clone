import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
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
          LikeButton(
            size: 25,
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
            likeCount: likes.length,
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
