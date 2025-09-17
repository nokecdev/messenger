import 'dart:async';
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
import 'package:signalr_chat/utils/methods.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _searchController = TextEditingController();

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

  
  Future<ChatRoomsResponse?> initRooms() async {
    try {

      final apiService = context.read<ApiService>();
      final userStorage = UserStorage();

      final token = await userStorage.getToken();
      if (token == null) {
        if (!mounted) return null;
        Navigator.pushReplacementNamed(context, '/login');
        return null;
      }

      final resp = await apiService.getAllChatRoom();
      if (!mounted) return null;

      if (resp != null) {
        if (resp.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(resp.body);
          final response = ChatRoomsResponse.fromJson(jsonMap);
          print(resp.body);
          return response;
        } else if (resp.statusCode == 404) {
          //TODO: Display no chatrooms found message.
        }
      } else {
        showSnackbar(context, message: "Nem sikerült betölteni a szobákat");
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (!mounted) return null;
      showSnackbar(context, message: "Hiba történt: $e");
      Navigator.pushReplacementNamed(context, '/login');
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      drawer: const ChatRoomsDrawer(),
      appBar: const ChatRoomHeader(),
      body: FutureBuilder<ChatRoomsResponse?>(
        future: initRooms(),
        builder: (context, asyncSnapshot) {
          final rooms = asyncSnapshot.data;
          return Container(
            decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
            child: Column(children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: TextField(
              //     autofocus: false,
              //     controller: _searchController,
              //     decoration: InputDecoration(
              //         border: const OutlineInputBorder(),
              //         hintText: 'Search by name or message...',
              //         hintStyle: const TextStyle(color: Color(0xFFC9C7C7)),
              //         suffixIcon: IconButton(
              //             icon: const Icon(Icons.search),
              //             onPressed: () => print("search..."))),
              //   ),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: rooms?.chatRooms.length,
                  itemBuilder: (context, index) {
                  var chatPartner = rooms?.chatRooms[index].chatPartner;
                  var userAvatar = chatPartner?.avatar ?? '';
                  var title = "${chatPartner?.firstName} ${chatPartner?.lastName}";
                  var lastMessage = rooms?.chatRooms[index].lastMessage ?? "";
                  var endedTime =  rooms?.chatRooms[index].endedDateTime.toString() ?? DateTime.now().toString();
                  final dateTime = DateTime.parse(endedTime);
                  final formattedTime = formatDate(dateTime);
                  var chatRoomId = rooms?.chatRooms[index].chatRoomId;

                  return Card(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: () async {
                          await Navigator.pushNamed(context, '/messages', arguments: chatRoomId);
                      },
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/blank_profile_pic.png")
                        // backgroundImage:  userAvatar.isNotEmpty ? 
                        //                   AssetImage("assets/blank_profile_pic.png") :
                        //                   NetworkImage(userAvatar.toString()) as ImageProvider
                      ),
                      title: Text(title),
                      subtitle: Text(lastMessage),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.circle_rounded,
                            color: Colors.green,
                            size: 10,                            
                          ),
                          const SizedBox(height: 12), // kis távolság
                          Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  );
                },
              ))
            ]),
          );
        }
      )
    );
  }
}
