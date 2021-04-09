import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../data_sources/number_trivia_local_data_source.dart';
import '../data_sources/number_trivia_remote_data_source.dart';

typedef Future<NumberTrivia> _GetAnyTrivia(); //Concrete Or Random Chooser  //* biz burada alacağımız fonksiyon NumberTrivia dönsün dedik ama NumberTriviaModel dönen fonksiyonlar atadık yukarıda. Bunun çalışma sebebi polimorfizm. NumberTriviaModel zaten NumberTrivia'dan türediği için hiçbir sorun çıkmadan çalışıyor.

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource
      remoteDataSource; //Repository bu veri kaynaklarıyla ilgili hiç bir şey bilmiyor sadece abstract sınıflarını yani contractlarını biliyor. Bu sayede bunları istediği gibi rahat rahat kullanıyor tek derdi verinin gelmesi ve hatalar. Verinin nasıl geldiğini vb hiç bilmiyor.
  final NumberTriviaLocalDataSource localeDataSource;
  final NetworkInfo
      networkInfo; //örneğin bunu da bilmiyor. Sadece network içinde isConnected diye bir property olduğunu biliyor ve onu kullanıyor. NetworkInfo nun nasıl isConnected verisini çektiğini vb bilmiyor.

  NumberTriviaRepositoryImplementation(
      {@required this.remoteDataSource,
      @required this.localeDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _GetAnyTrivia triviaGettingFunction) async {
   
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await triviaGettingFunction();
        localeDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localeDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

/*
 Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        localeDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localeDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();

        localeDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localeDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
*/
