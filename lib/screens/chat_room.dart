import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/chat_rooms_response.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_chat/Widgets/States/chat_room_header.dart';
import 'package:signalr_chat/Widgets/States/chat_rooms_drawer.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';
import 'package:signalr_chat/Widgets/snackbar.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  final ChatRoomsResponse? chatRooms = null;


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initRooms();
  }

  
  Future<void> initRooms() async {
    try {

      final apiService = context.read<ApiService>();
      final userStorage = UserStorage();

      final token = await userStorage.getToken();
      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final chatRooms = await apiService.getAllChatRoom();
      print(chatRooms?.statusCode);
      print("Received response from service");
      print(chatRooms?.body);

      if (!mounted) return;

      if (chatRooms != null) {
        if (chatRooms.statusCode == 200) {
          print("response: ${chatRooms.body}");

          final Map<String, dynamic> jsonMap = jsonDecode(chatRooms.body);
          final response = ChatRoomsResponse.fromJson(jsonMap);

          print("Összes szoba: ${response.chatRooms.length}");
          print("Első szoba ID: ${response.chatRooms.first.chatRoomId}");
        }
       //Navigator.pushReplacementNamed(context, '/rooms');
      } else {
        showSnackbar(context, message: "Nem sikerült betölteni a szobákat");
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (!mounted) return;
      showSnackbar(context, message: "Hiba történt: $e");
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
        drawer: const ChatRoomsDrawer(),
        appBar: const ChatRoomHeader(),
        body: Container(
          decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                autofocus: false,
                controller: _searchController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Search by name or message...',
                    hintStyle: const TextStyle(color: Color(0xFFC9C7C7)),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => print("search..."))),
              ),
            ),
            // Expanded(
            //     child: ListView.builder(
            //   itemCount: mappedData.keys.length,
            //   itemBuilder: (context, index) {
            //     Map<String, dynamic> key = mappedData.keys.elementAt(index);
            //     Map<String, dynamic> value = mappedData[key]!;

            //     var userAvatar = value['avatar'].toString();
            //     var chatContents = key['chatContents'];

            //     return Card(
            //         color: Colors.transparent,
            //         child: ListTile(
            //           onTap: () async {
            //             await Navigator.pushNamed(context, '/messages',
            //                 arguments: mappedData);
            //           },
            //           leading: CircleAvatar(
            //             backgroundImage: userAvatar.isNotEmpty
            //                 ? NetworkImage(
            //                     "https://storage.googleapis.com/socialstream/$userAvatar")
            //                 : const AssetImage('assets/blank_profile_pic.png')
            //                     as ImageProvider,
            //           ),
            //           title: Text("${chatContents[0]['message']}"),
            //           subtitle: Text("${chatContents[0]['sentDate']}"),
            //           trailing: const Icon(
            //             Icons.circle_rounded,
            //             color: Colors.green,
            //           ),
            //         ));
            //   },
            // ))
          ]),
        ));
  }
}
