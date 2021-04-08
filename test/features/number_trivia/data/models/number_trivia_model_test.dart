import 'dart:convert';

import 'package:flutter_clean_architecture_reso/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_reso/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

main() {
  final tNumberTriviaModel = NumberTriviaModel(
      number: 50,
      text:
          "50 Test is the number of planck volumes in the observable universe.");

  test("should be a subclass of NumberTrivia entity", () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return a valid model when the JSON number is an integer",
        () async {
      //Arrange
      final Map<String, dynamic> jsonMapFake = jsonDecode(fixture(
          "trivia.json")); //İnternetten veri çekip decode ettik gibi düşün

      //Act
      final result = NumberTriviaModel.fromJSON(
          jsonMapFake); //json ile bir model türettik klasik fromjson işte
      expect(result, tNumberTriviaModel);
    });
  });

  group("fromJsonDouble", () {
    test(
        "should return a valid model when the JSON number is regarded as a double",
        () async {
      //Arrange
      final Map<String, dynamic> jsonMapFake = jsonDecode(fixture(
          "trivia_double.json")); //İnternetten veri çekip decode ettik gibi düşün

      //Act
      final result = NumberTriviaModel.fromJSON(
          jsonMapFake); //json ile bir model türettik klasik fromjson işte
      expect(result, tNumberTriviaModel);
    });
  });

  group("toJSON", () {
    test("should return a JSON map containing the proper data", () async {
      final result = tNumberTriviaModel.toJson();

      expect(result, {
        "text":
            "50 Test is the number of planck volumes in the observable universe.",
        "number": 50
      });
    });
  });
}
