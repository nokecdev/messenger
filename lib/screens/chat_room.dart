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
  final ScrollController _scrollController = ScrollController();
  final apiService = ApiService();
  List<ChatRoomDto>? rooms;
  PaginationDto? roomMetadata;

  bool isLoadingMore = false;
  bool hasMoreChatRoom = true;
  int chatRoomOffset = 15;
  int currentPage = 1;
  int totalPage = 5;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initRooms();

    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 50 &&
          !isLoadingMore &&
          currentPage <= totalPage) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {
    currentPage++;
    _fetchChatRooms();
  }

 Future<void> _fetchChatRooms() async {
    setState(() => isLoadingMore = true);
    var res = await apiService.getAllChatRoom(currentPage: currentPage);
    setState(() {
      if (res != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(res.body);
        final obj = ChatRoomsResponse.fromJson(jsonMap);
        rooms = [...(rooms ?? []), ...obj.chatRooms];
        totalPage = obj.roomPagination.totalPage;
        hasMoreChatRoom = obj.roomPagination.totalPage >= currentPage;
      }
      isLoadingMore = false;
    });
  }
  
  Future<void> initRooms() async {
    try {
      final userStorage = UserStorage();

      final token = await userStorage.getToken();
      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final resp = await apiService.getAllChatRoom();
      if (!mounted) return;

      if (resp != null) {
        if (resp.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(resp.body);
          final response = ChatRoomsResponse.fromJson(jsonMap);
          setState(() {
            rooms = response.chatRooms;
            totalPage = response.roomPagination.totalPage;
            roomMetadata = response.roomPagination;
            hasMoreChatRoom = response.roomPagination.totalPage >= currentPage;
          });
        } else if (resp.statusCode == 404) {
          //TODO: Display no chatrooms found message.
        }
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
                controller: _scrollController,
                itemCount: rooms?.length,
                itemBuilder: (context, index) {
                var chatPartner = rooms?[index].chatPartner;
                var userAvatar = chatPartner?.avatar ?? '';
                var title = "${chatPartner?.firstName} ${chatPartner?.lastName}";
                var lastMessage = rooms?[index].lastMessage ?? "";
                var endedTime =  rooms?[index].endedDateTime.toString() ?? DateTime.now().toString();
                final dateTime = DateTime.parse(endedTime);
                final formattedTime = formatDate(dateTime);
                var chatRoomId = rooms?[index].chatRoomId;
                var totalChatRoom = rooms!.length - 1;
                print("metadata ${roomMetadata?.total}");
                print("total: ${index+1}");

                if (!hasMoreChatRoom && index == totalChatRoom) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(12),
                      child: Text("Nincs több cset előzmény")
                    ),
                  );
                }
                else if (index == totalChatRoom) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

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
            )
          )]
        ),
      )
    );
  }
}
