import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

const serverUrl = "http://10.0.2.2:5000";

// ignore: must_be_immutable
class HubConnection extends StatelessWidget {
  HubConnection({required this.hubConnection, super.key});
  var hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
