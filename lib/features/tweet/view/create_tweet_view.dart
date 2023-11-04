import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/theme/theme.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    tweetController.dispose();
  }

  void shareTweet() {
    final tweetNotifier = ref.read(tweetControllerNotifierProvider.notifier);
    tweetNotifier.shareTweet(
      images: images,
      text: tweetController.text,
      context: context,
      repliedTo: '',
    );
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundSmallButton(
            onTap: shareTweet,
            label: 'Tweet',
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: currentUser == null
          ? Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: tweetController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        )
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((file) => Image.file(file)).toList(),
                        options: CarouselOptions(
                          height: 200,
                          enableInfiniteScroll: false,
                        ),
                      )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(AssetsConstants.gifIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(AssetsConstants.emojiIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
