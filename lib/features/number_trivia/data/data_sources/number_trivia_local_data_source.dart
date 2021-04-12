import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  //Buraları da abstract yapıp dependency inversion prensibinden yararlanıyoruz. Gördüğün gibi lokal veri kaynağıyla ilgili hiçbir şey belirtilmemiş yani shared preferences mi olucak, hive mi olucak belli değil sadece yaptıkları işler belli
//bunun sebebi de şu: Yarın bigün sharedpreferences kullanımından hive kullanımına geçince veya sqflite kullanımına geçince bizim repository'nin data layerdeki kısmı bunu bilmesin yani repository'nin hiç haberi olmasın. O sadece verinin gelip gelmeyeceğine ve hataya bakıyor veri çekmek ile ilgili. Verinin çekilme yöntemini bilmemesi lazım.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel);
}

const CACHE_NUMBER_TRIVIA = "CACHE_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImplementation
    implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImplementation({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(
        CACHE_NUMBER_TRIVIA); //Çoğu local data source paketi futurelar ile çalışacağı için biz contract sınıfımızdaki metodları yani LocalDataSource için yaptığımız abstract sınıftaki metodları hep Future dönen şekilde yaptık ki garanti olsun. Şimdi bu sharedpreferences senkron çalıştığı için future döndürmüyor ama biz bunun future döndürmesini istediğimiz için Future.value() yaparak döndürüyoruzç
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJSON(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModel) {
    sharedPreferences.setString(
      CACHE_NUMBER_TRIVIA,
      json.encode(triviaModel.toJson()),
    );
    return Future.value();
  }
}
