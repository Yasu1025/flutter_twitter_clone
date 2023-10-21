import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/common/rounded_small_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/theme/theme.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController(text: 'test12345@gmail.com');
  final passwordController = TextEditingController(text: 'test123456');

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        'Singup',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthField(
                        controller: emailController,
                        hintText: 'email',
                      ),
                      const SizedBox(height: 25),
                      AuthField(
                        controller: passwordController,
                        hintText: 'password',
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundSmallButton(
                          onTap: onSignUp,
                          label: 'sign up',
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                          text: "You already have an account?",
                          children: [
                            TextSpan(
                              text: " Log in",
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, LoginView.route());
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
