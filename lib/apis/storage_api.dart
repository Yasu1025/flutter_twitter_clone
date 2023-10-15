import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPi(storage: storage);
});

class StorageAPi {
  final Storage _storage;

  StorageAPi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (var file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppWriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      final imageUrl = AppWriteConstants.imageUrl(uploadedImage.$id);
      imageLinks.add(imageUrl);
    }

    return imageLinks;
  }
}
