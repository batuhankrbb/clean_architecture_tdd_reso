import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  //repository'nin bunun implementasyonunu da bilmemesi lazım o yüzden bunu da diğer servisler gibi abstract yaptık ve contrac yaptık.
  Future<bool> get isConnected;
}

class NetworkInfoImplementation implements NetworkInfo {
  final DataConnectionChecker
      connectionChecker; //* DataConnectionChecker sınıfı paketten geliyor

  NetworkInfoImplementation(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
    
}
