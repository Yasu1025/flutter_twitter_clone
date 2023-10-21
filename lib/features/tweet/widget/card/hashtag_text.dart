import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];
    text.split(' ').forEach((t) {
      if (t.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$t ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (t.startsWith('www.') ||
          t.startsWith('http://') ||
          t.startsWith('https://')) {
        textspans.add(
          TextSpan(
            text: '$t ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$t ',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(children: textspans),
    );
  }
}
