/*
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

*/
