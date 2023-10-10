import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppWriteConstants {
  // env
  static final String databaseId = dotenv.get('APPWRITE_DATABASE_ID');
  static final String projectId = dotenv.get('APPWRITE_PROJECT_ID');
  static final String endPoint = dotenv.get('APPWRITE_END_POINT');

  // DB collections
  static final String usersCollection = dotenv.get('APPWRITE_USERS_COLLECTION');
}
