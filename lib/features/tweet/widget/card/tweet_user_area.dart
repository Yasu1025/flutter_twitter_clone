import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetUserArea extends StatelessWidget {
  final String name;
  final DateTime tweetedAt;
  const TweetUserArea({super.key, required this.name, required this.tweetedAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ),
        Text(
          '@$name・${timeago.format(
            tweetedAt,
            locale: 'en_short',
          )}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Pallete.greyColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
