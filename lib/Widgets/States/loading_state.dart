import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:signalr_chat/Services/api_service.dart';

class LoadingState with ChangeNotifier {
  final ApiService apiService;
  final log = Logger('MyClassName');

  LoadingState(this.apiService);

  Future<void> loadData(String endpoint) async {
    // Perform the data fetching here using the apiService
    //await apiService.getAllChatRoom(1491);
    log.info("load data in lState");
    notifyListeners();
  }
}
