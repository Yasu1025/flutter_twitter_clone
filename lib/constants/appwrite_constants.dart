import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppWriteConstants {
  // env
  static final String databaseId = dotenv.get('APPWRITE_DATABASE_ID');
  static final String projectId = dotenv.get('APPWRITE_PROJECT_ID');
  static final String endPoint = dotenv.get('APPWRITE_END_POINT');

  // DB collections
  static final String usersCollection = dotenv.get('APPWRITE_USERS_COLLECTION');
  static final String tweetsCollection =
      dotenv.get('APPWRITE_TWEETS_COLLECTION');
  static final String notificationCollection =
      dotenv.get('APPWRITE_NOTIFICATION_COLLECTION');

  // bucket ID
  static final String imagesBucketId = dotenv.get('APPWRITE_IMAGES_BUCKET_ID');
  static String tweetColletionPath =
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollection}.documents';
  static String tweetColletionCreatePath =
      'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.create';
  static String tweetColletionUpdatePath =
      'databases.*.collections.${AppWriteConstants.tweetsCollection}.documents.*.update';

  static String userCollectionPath =
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.usersCollection}.documents';
  static String userCollectionUpdatePath(String uid) =>
      'databases.*.collections.${AppWriteConstants.usersCollection}.documents.$uid.update';

  static String imageUrl(String imageID) =>
      '${endPoint}/storage/buckets/${imagesBucketId}/files/${imageID}/view?project=${projectId}&mode=admin';
}
