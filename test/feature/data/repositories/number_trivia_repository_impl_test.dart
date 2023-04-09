import 'package:clean_architecutre_reso_coder/core/platform/network_info.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  
  setUp((){
  mockLocalDataSource = MockLocalDataSource();
  mockRemoteDataSource = MockRemoteDataSource();
  mockNetworkInfo = MockNetworkInfo();
  repository = NumberTriviaRepositoryImpl(
    numberTriviaRemoteDataSource: mockRemoteDataSource,
    numberTriviaLocalDataSource: mockLocalDataSource,
    networkInfo: mockNetworkInfo
  );

});  
}
