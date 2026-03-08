import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Generic base class for all use cases in the domain layer.
///
/// [T]  - success return type (e.g. ScannedDocument, List[ScannedDocument], Unit, etc.)
/// [Params] - parameters type (can be a dedicated class or [NoParams] for none).
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Convenience type for use cases that do not require any parameters.
class NoParams {
  const NoParams();
}