import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/twitter_reply_view.dart';
import 'package:twitter_clone/features/tweet/widget/card/carousel_images.dart';
import 'package:twitter_clone/features/tweet/widget/card/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widget/card/tweet_action_buttons.dart';
import 'package:twitter_clone/features/tweet/widget/card/tweet_user_area.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard(this.tweet, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserAccountProvider).value;

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (userInfo) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, TwitterReplyScreen.route(tweet));
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              userInfo.profilePic,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tweet.resharedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        color: Pallete.greyColor,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${tweet.resharedBy} retweeted',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                //retweeted
                                TweetUserArea(
                                  name: userInfo.name,
                                  tweetedAt: tweet.tweetedAt,
                                ),
                                const SizedBox(height: 10),
                                // Replied to
                                if (tweet.repliedTo.isNotEmpty)
                                  ref
                                      .watch(
                                          getTweetByIdProvider(tweet.repliedTo))
                                      .when(
                                        data: (repliedTweet) {
                                          return RichText(
                                            text: const TextSpan(
                                              text: 'Repluing to',
                                              style: TextStyle(
                                                color: Pallete.greyColor,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '@ name todo',
                                                  style: TextStyle(
                                                    color: Pallete.greyColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, st) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => const Loader(),
                                      ),

                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarouselImages(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  AnyLinkPreview(
                                    link: 'https://${tweet.link}',
                                  ),
                                ],
                                TweetActionButtons(
                                  tweet: tweet,
                                  user: userInfo,
                                ),
                                const SizedBox(height: 1),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(color: Pallete.greyColor),
                    ],
                  ),
                );
              },
              error: (error, st) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
