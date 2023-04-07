import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  GetConcreteNumberTrivia? useCase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  test(
    'should get trivia for the number from repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository!
              .getConcreteNumberTrivia(tNumberTrivia.number))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      //act
      final result = await useCase!(const Params(number: tNumber));

      //assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository!.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
