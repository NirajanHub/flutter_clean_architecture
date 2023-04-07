import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/platform/network_info.dart';
import '../data_sources/number_trivia_remote_datasource.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.numberTriviaLocalDataSource,
      required this.numberTriviaRemoteDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
