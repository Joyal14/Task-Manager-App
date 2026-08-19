import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { wifi, cellular, offline }

class NetworkUtil {
  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  NetworkUtil() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      connectionStatusController.add(_getStatusFromResult(result.first));
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.offline;
      default:
        return ConnectivityStatus.offline;
    }
  }
}
