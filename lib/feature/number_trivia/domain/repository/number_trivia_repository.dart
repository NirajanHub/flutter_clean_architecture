import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>?>? getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>?>? getRandomNumberTrivia();
}
