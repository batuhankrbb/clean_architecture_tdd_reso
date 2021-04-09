abstract class NetworkInfo {  //repository'nin bunun implementasyonunu da bilmemesi lazım o yüzden bunu da diğer servisler gibi abstract yaptık ve contrac yaptık.
  Future<bool> get isConnected;
}
