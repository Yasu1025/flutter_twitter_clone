import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failuer.dart';

typedef FutureEither<T> = Future<Either<Failuer, T>>; // T is success
typedef FutureEitherVoid = FutureEither<void>;
