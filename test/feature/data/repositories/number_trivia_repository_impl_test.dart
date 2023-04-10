import 'package:clean_architecutre_reso_coder/core/error/exceptions.dart';
import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/core/network/network_info.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  NumberTriviaRepositoryImpl? repository;
  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        numberTriviaRemoteDataSource: mockRemoteDataSource,
        numberTriviaLocalDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() =>
          {when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true)});
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is online', () {
      setUp(() =>
          {when(mockNetworkInfo!.isConnected).thenAnswer((_) async => false)});
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    // test(
    //   'should check if device is online',
    //   () async {
    //     when(mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
    //     //act
    //     repository!.getConcreteNumberTrivia(tNumber);
    //     //assert
    //     verify(mockNetworkInfo!.isConnected);
    //   },
    // );

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        //here equals is not required, we are placing equals to make it easy to read and understand the test.
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
        expect(result, const Right(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result, const Left(ServerFailure()));
      });
    });
    runTestOffline(
      () {
        test('should return last locally cached data when cache is present',
            () async {
          //arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          //assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, const Right(tNumberTrivia));
        });
        test(
            'should return no data if locally cached data when cache is not present',
            () async {
          //arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository!.getConcreteNumberTrivia(tNumber);
          //assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, const Left(CacheFailure()));
        });
      },
    );
  });
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 123);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    // test(
    //   'should check if device is online',
    //   () async {
    //     when(mockNetworkInfo!.isConnected!).thenAnswer((_) async => true);
    //     //act
    //     repository!.getRandomNumberTrivia();
    //     //assert
    //     verify(mockNetworkInfo!.isConnected!);
    //   },
    // );

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository!.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        //here equals is not required, we are placing equals to make it easy to read and understand the test.
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository!.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verify(mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
        expect(result, const Right(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource!.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository!.getRandomNumberTrivia();
        //assert
        verify(mockRemoteDataSource!.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockLocalDataSource);
        expect(result, const Left(ServerFailure()));
      });
    });
    runTestOffline(
      () {
        test('should return last locally cached data when cache is present',
            () async {
          //arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          //act
          final result = await repository!.getRandomNumberTrivia();
          //assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, const Right(tNumberTrivia));
        });
        test(
            'should return no data if locally cached data when cache is not present',
            () async {
          //arrange
          when(mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository!.getRandomNumberTrivia();
          //assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource!.getLastNumberTrivia());
          expect(result, const Left(CacheFailure()));
        });
      },
    );
  });
}
