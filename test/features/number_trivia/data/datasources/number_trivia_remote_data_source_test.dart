import 'dart:html';

import 'package:flutter_clean_architecture_reso/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class MockHTTPClient extends Mock implements http.Client {}

main() {
  NumberTriviaRemoteDataSourceImplementation dataSourceImplementation;

  MockHTTPClient mockHTTPClient;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    dataSourceImplementation =
        NumberTriviaRemoteDataSourceImplementation(client: mockHTTPClient);
  });
}
