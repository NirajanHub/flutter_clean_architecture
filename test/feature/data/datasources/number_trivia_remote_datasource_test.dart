import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
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

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    test('''should  perform a GET request on a URL with number being 
    endpoint and with applicaion/json header''', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient
          .get(Uri.tryParse('http://numbersapi.com/$tNumber')!, headers: {
        'Content-Type': 'application/json',
      }));
    });
  });
}
