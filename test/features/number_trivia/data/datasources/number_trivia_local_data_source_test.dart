import 'dart:convert';

import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImplementation
      dataSource; //local datasource implementasyonu
  MockSharedPreferences mockSharedPreferences; //içine aldığı sharedpreferences

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImplementation(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(fixture("trivia_cache.json")));
    test(
        "should return numbertrivia from sharedpreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences
              .getString(any)) // sharedden alınca belirttiğimiz json dönüyor
          .thenReturn(fixture("trivia_cache.json"));

      //act
      final result = await dataSource.getLastNumberTrivia();

      //assert
      verify(mockSharedPreferences.getString(CACHE_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
  });
}
