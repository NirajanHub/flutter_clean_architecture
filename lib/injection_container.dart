import 'package:clean_architecutre_reso_coder/core/network/network_info.dart';
import 'package:clean_architecutre_reso_coder/core/util/input_converter.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/data_sources/number_trivia_local_datasource.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/data/repositories/number_trivia_repo_impl.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architecutre_reso_coder/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/number_trivia/data/data_sources/number_trivia_remote_datasource.dart';
import 'feature/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.asNewInstance();

Future<void> init() async {
  //!Features - Number Trivia
  //BLoc
  sl.registerFactory(() => NumberTriviaBloc(sl(), sl(), sl()));

  //Use Cases

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

//Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      numberTriviaLocalDataSource: sl(),
      numberTriviaRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

//Data Sources

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
