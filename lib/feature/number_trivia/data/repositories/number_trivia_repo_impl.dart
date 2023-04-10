import 'package:clean_architecutre_reso_coder/core/error/exceptions.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../data_sources/number_trivia_remote_datasource.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource? numberTriviaLocalDataSource;
  final NumberTriviaRemoteDataSource? numberTriviaRemoteDataSource;
  final NetworkInfo? networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.numberTriviaLocalDataSource,
      required this.numberTriviaRemoteDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource!.getConcreteNumberTrivia(number)!;
    })!;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return numberTriviaRemoteDataSource!.getRandomNumberTrivia()!;
    })!;
  }

  Future<Either<Failure, NumberTrivia>>? _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo!.isConnected!) {
      try {
        final remoteNumberTrivia = await getConcreteOrRandom();
        numberTriviaLocalDataSource!.cacheNumberTrivia(remoteNumberTrivia);
        return Right(remoteNumberTrivia);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource!.getLastNumberTrivia()!;
        return Right(localTrivia);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }
}
