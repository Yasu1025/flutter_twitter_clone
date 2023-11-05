import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(ref.watch(userAPIProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController(this._userAPI) : super(false);

  Future<List<User>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((user) => User.fromMap(user.data)).toList();
  }
}
