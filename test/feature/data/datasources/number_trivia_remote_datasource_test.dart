import 'package:clean_architecutre_reso_coder/core/error/exceptions.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSource dataSource;
  final mockHttpClient = MockClient();

  setUp(() {
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Server Exception', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: 1);
    test('''should  perform a GET request on a URL with number being 
    endpoint and with applicaion/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient
          .get(Uri.tryParse('http://numbersapi.com/$tNumber')!, headers: {
        'Content-Type': 'application/json',
      }));
    });
    test('''should return number trivia when the success code is 200''',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });
    test(
        '''should throw a ServerException when the response code is 404 or other''',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final result = dataSource.getConcreteNumberTrivia;
      //assert
      expect(
          () => result(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: 1);
    test('''should  perform a GET request on a URL with number being 
    endpoint and with applicaion/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient
          .get(Uri.tryParse('http://numbersapi.com/random')!, headers: {
        'Content-Type': 'application/json',
      }));
    });
    test('''should return number trivia when the success code is 200''',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });
    test(
        '''should throw a ServerException when the response code is 404 or other''',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final result = dataSource.getRandomNumberTrivia()!;
      //assert
      expect(() => result, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
