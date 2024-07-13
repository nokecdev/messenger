import 'package:flutter/foundation.dart';
import 'package:signalr_chat/Services/ApiService.dart';

class LoadingState with ChangeNotifier {
  final ApiService apiService;

  LoadingState(this.apiService);

  Future<void> loadData(String endpoint) async {
    // Perform the data fetching here using the apiService
    //await apiService.getAllChatRoom(1491);
    print("load data in lState");
    notifyListeners();
  }
}
