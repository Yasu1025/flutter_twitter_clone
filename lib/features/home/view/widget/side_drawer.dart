import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/theme/theme.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : SafeArea(
            child: Drawer(
              backgroundColor: Pallete.backgroundColor,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    title: const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        UserProfileView.route(currentUser),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.payment,
                      size: 30,
                    ),
                    title: const Text(
                      'Twitter Blue',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout(context);
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
