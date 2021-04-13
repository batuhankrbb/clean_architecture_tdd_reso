import 'dart:developer';

import 'package:flutter_clean_architecture_reso/core/network/network_info.dart';
import 'package:flutter_clean_architecture_reso/core/util/input_converter.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

///* repository, datasource, usecase gibi şeyler app boyunca sadece 1 tane olacağı için zaten burada getit ile dependency injection yapıyoruz.
///*  Hani ben normalde swiftde her şeyi singleton yapıyordum ya repositoryi, servisleri vb. Burada da singleton yapmak yerine normal yapıp getit ile dependency injection yapıyoruz.
///* Singleton ile uğraşmıyoruz. Kısacası repodan, servisten vb sadece 1 tane var.
///* Hatta Core içindeki ApiService, networkInfo gibi çoğu şey de singleton olacağı için onları da burada singleton yapıyoruz.
///* Paketlerdeki SharedPreferences objesini vb de burada singleton yapıyoruz
///* Aslında sadece singleton da değil. Mesela bloc'un sürekli yeni instance olması gerekiyor singleton olmaması gerekiyor. Bu yüzden Factory olarak Register ediyoruz o tarz şeyleri de. Bu sayede sürekli yeni instance veriyor.
///* CleanUp olması gereken yani dispose kullanan classlar (Bloc gibi) singleton olarak register edilmemeli.
GetIt getIt = GetIt.instance;

Future<void> init() async{
  //! Features - Number Trivia
  //bloc
  getIt.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia:
          getIt(), //bu getIt() yaptığımız aslında bir callable class olduğu için getIt.call() yapmış oluyoruz. Bu call metodu içinde de şu oluyor: GetIt instance'ı GetIt'e register olmuş bütün type lara bakmaya başlıyor. Daha sonra o type ile eşleşen type'ı alıyor onu kullanıyor.
      inputConverter: getIt(),
      getRandomNumberTrivia: getIt(),
    ),
  );

  //use case
  //Use caseler repoya değil de reponun contract sınıfına yani abstract sınıfa bağlı.
  getIt.registerLazySingleton(() => GetConcreteNumberTrivia(
      getIt())); //Aynı şekilde bunda da arıyor, repository instance bulunca alıp koyuyor.
  getIt.registerLazySingleton(() => GetRandomNumberTrivia(
      getIt())); //Aynı şekilde bunda da arıyor, repository instance bulunca alıp koyuyor.

//Repository

//? Bak burası çokomelli. Şimdi bizim repository'nin contract amaçlı olan NumberTriviaRepository isimli bir abstract sınıfı var ve NumberTriviaRepository kullanan bütün her şey (use caseler vb.) bu abstract sınıfa bağlı.
//? Nasıl implemente edildiği umrunda değil. Bu yüzden repository register ederken <NumberTriviaRepository> yaparak o abstract sınıf tipini belirtiyoruz. Initialize ederken NumberTriviaRepositoryImplementation kullanıyoruz.
//? Tipini belirttiğimiz için bizim aslında bu register ettiğimiz şey NumberTriviaRepository olarak algılanıyor yani implementasyonu bilmiyor. Şey gibi düşün. b ve a sınıfı var ve b sınıfı a dan türüyor. A bDenBirObje = b yapsak b, a yı kabul ettiği için atama gerçekleşir ama bDenBirObje yi kullananlar bunu A objesiymiş gibi kullanabilir.
//? Bunu yapıyoruz çünkü diğer kısımların hepsi bizim Repositry Contract olan abstract sınıfına bağlı. Diğer metodları bilmelerine gerek yok ki çok yanlış olur tüm mimari çöpe gider.
//? Mantık olarak bakarsan da abstract class'ı tip olarak tanımlayıp neden implementasyon ile init ediyoruz diye, abstract class contract amaçlı ve zaten ondan init edilemez. Aynı zamanda yukarıdaki use caselerin vb değişkenine call metodunu çağırdık. O gidecek abstract contract olan NumberTriviaRepository sınıfını arıyacak ama eğer biz burada tipi implementasyon yaparsak, aradığını bulamayacak ve hata verecek.
//? Bu şekilde yapınca yani tipi contract sınıfımız yapınca, implementasyonu da istediğimiz gibi değiştiririz. Contract sınıfı conform ettiği sürece hiçbir sorun da çıkmaz app takır takır çalışır
  getIt.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImplementation(
          remoteDataSource: getIt(),
          localeDataSource: getIt(),
          networkInfo: getIt()));

  //Data Sources

  getIt.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImplementation(client: getIt()),
  );

  getIt.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImplementation(sharedPreferences: getIt()),
  );

  //! Core
  getIt.registerLazySingleton(() => InputConverter());

  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(getIt()));
  //! External

  getIt.registerLazySingletonAsync<SharedPreferences>( () async => await SharedPreferences.getInstance());
  getIt.registerLazySingleton( () => http.Client());
  getIt.registerLazySingleton( () => DataConnectionChecker());
  
}
