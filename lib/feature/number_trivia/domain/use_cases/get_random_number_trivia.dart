// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/core/usecases/usecase.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>?>? call(NoParams? params) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}
