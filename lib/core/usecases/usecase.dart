import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>?>? call(Params params);
}
