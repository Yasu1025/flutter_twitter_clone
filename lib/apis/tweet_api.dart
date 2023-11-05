import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failuer.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDBProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TweetAPI(db: db, realtime: realtime);
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliedToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getUserTweets(String uid);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final doc = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );

      // ignore: avoid_print
      print('Tweet Successfully $doc');
      return right(doc);
    } on AppwriteException catch (e, st) {
      return left(
        Failuer(e.message ?? 'Some unexpected error occured...', st),
      );
    } catch (e, st) {
      return left(
        Failuer(e.toString(), st),
      );
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final docs = await _db.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        queries: [Query.orderDesc('tweetedAt')]);

    return docs.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe(
      [AppWriteConstants.tweetColletionPath],
    ).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final doc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );

      // ignore: avoid_print
      print('Tweet Successfully $doc');
      return right(doc);
    } on AppwriteException catch (e, st) {
      return left(
        Failuer(e.message ?? 'Some unexpected error occured...', st),
      );
    } catch (e, st) {
      return left(
        Failuer(e.toString(), st),
      );
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final doc = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );

      // ignore: avoid_print
      print('Tweet Successfully $doc');
      return right(doc);
    } on AppwriteException catch (e, st) {
      return left(
        Failuer(e.message ?? 'Some unexpected error occured...', st),
      );
    } catch (e, st) {
      return left(
        Failuer(e.toString(), st),
      );
    }
  }

  @override
  Future<List<Document>> getRepliedToTweet(Tweet tweet) async {
    final doc = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );

    return doc.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    return await _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final docs = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );

    return docs.documents;
  }
}
