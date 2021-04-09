import 'package:flutter_clean_architecture_reso/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

main(List<String> args) {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImplementation networkInfoImplementation;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImplementation =
        NetworkInfoImplementation(mockDataConnectionChecker);
  });

  group("isConnected", () {
    test("should forward the call to DataConnectionChecker.hasConnection",
        () async {
      final tHasconnectionFuture = Future.value(true);
      //arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) async => tHasconnectionFuture);
      //act
      final result = networkInfoImplementation.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
