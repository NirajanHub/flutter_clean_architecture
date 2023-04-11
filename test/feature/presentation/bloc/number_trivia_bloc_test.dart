import 'package:clean_architecutre_reso_coder/core/error/failures.dart';
import 'package:clean_architecutre_reso_coder/core/util/input_converter.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(mockGetConcreteNumberTrivia,
        mockGetRandomNumberTrivia, mockInputConverter);
  });

  test('initial State to be empty', () {
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test', number: tNumberParsed);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    test(
        'should call an Input Converter to validate and convert the string to an unsigned integer',
        () async {
      //arragne
      setUpMockInputConverterSuccess();

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is Invalid', () async {
      //arragne
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // As the event needs to be registered here and dispached using add so assert comes first while using bloc test.
      //assert later
      final expected = [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      expect(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
    test('should get data from concrete use case', () async {
      //arragne
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      //assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });
    test('should emit [Loading, Loaded] when data is gotten sucessfully',
        () async {
      //arragne
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      //assert later
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      //arragne
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Left(ServerFailure()));

      //assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
    test(
        'should emit [Loading, Error] with a proper error message getting data fails',
        () async {
      //arragne
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Left(CacheFailure()));

      //assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    test('should emit [Loading, Loaded] when data is gotten sucessfully',
        () async {
      //arragne
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      //assert later
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForRandomNumber());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      //arragne

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Left(ServerFailure()));

      //assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForRandomNumber());
    });
    test(
        'should emit [Loading, Error] with a proper error message getting data fails',
        () async {
      //arragne

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Left(CacheFailure()));

      //assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForRandomNumber());
    });
  });
}
