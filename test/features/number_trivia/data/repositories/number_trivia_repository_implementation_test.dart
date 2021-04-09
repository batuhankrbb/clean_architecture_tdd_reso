import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_reso/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_reso/core/error/failures.dart';
import 'package:flutter_clean_architecture_reso/core/network/network_info.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocaleDataSource extends Mock implements NumberTriviaLocalDataSource {
}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImplementation repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocaleDataSource mockLocaleDataSource;
  MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocaleDataSource = MockLocaleDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource: mockRemoteDataSource,
      localeDataSource: mockLocaleDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async =>
            true); //mocknetworkinfodan isconnected çağırılınca true diye cevap ver
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async =>
            false); //mocknetworkinfodan isconnected çağırılınca true diye cevap ver
      });
      body();
    });
  }

  group("getConcreteNumberTrivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async =>
          true); //mocknetworkinfodan isconnected çağırılınca true diye cevap ver

      //act
      repository.getConcreteNumberTrivia(tNumber);

      //assert

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        //act
        await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocaleDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "should return server failure when the call to remote data source is unseccessful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocaleDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        //? arrange
        when(mockLocaleDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //? act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocaleDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "should return cache failure when there is no cached data present and no internet",
          () async {
        //? arrange
        when(mockLocaleDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //? act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocaleDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test Trivia", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async =>
          true); //mocknetworkinfodan isconnected çağırılınca true diye cevap ver

      //act
      repository.getRandomNumberTrivia();

      //assert

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocaleDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "should return server failure when the call to remote data source is unseccessful",
          () async {
        //Arrange
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocaleDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        //? arrange
        when(mockLocaleDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        //? act
        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocaleDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test(
          "should return cache failure when there is no cached data present and no internet",
          () async {
        //? arrange
        when(mockLocaleDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        //? act
        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocaleDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
