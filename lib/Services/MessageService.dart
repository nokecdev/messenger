// Import the library.
import 'package:signalr_netcore/signalr_client.dart';

class MessageService {
  // The location of the SignalR Server.
  final String serverUrl = "ws://localhost:5000/Chat"; //"http://10.0.2.2:5000";
  late HubConnection hubConnection;
  // Creates the connection by using the HubConnectionBuilder.
  void Build() async {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    await hubConnection.start();
  }

  void sendMessage(String user, String message) {
    hubConnection.invoke('SendMessage', args: [user, message]);
  }

  void watchIncomingMessage() {
    hubConnection.on('ReceiveMessage', (args) {
      // Handle incoming message here
      int fromUserId = int.parse(args[0]);
      int userId = int.parse(args[1]);
      String message = args[2];
    });

  }
}
