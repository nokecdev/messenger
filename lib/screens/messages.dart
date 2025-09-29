import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/chat_content.dart';
import 'package:signalr_chat/Models/chat_partner_dto.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';
import 'package:signalr_chat/Widgets/gradient_scaffold.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

enum MenuItem { itemOne, itemTwo, itemThree }

class _MessageViewState extends State<MessageView> {
  List<Chatcontent> messages = [];
  var chatPartner = ChatPartnerDto(avatar: '', firstName: '', lastName: '', chatRoomId: '');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    //Mivel még az initben nem elérhető az arg, lebuildeljük a kódot majd utólag kinyerjük a csetszoba Id-ját.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as ChatPartnerDto;
      setState(() {
        chatPartner = args; //ChatPartnerDto.fromJson(args);      
      });
      print('received chatPartner:');
      initMessages();
    });
  }

  
  Future<void> initMessages() async {
    final userStorage = UserStorage();
    final apiService = ApiService();

    try {
      final token = await userStorage.getToken();

      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      print("Room id: ${chatPartner.chatRoomId}");
      var resp = await apiService.getChatContents(chatPartner.chatRoomId);
      if (!mounted) return;

      print(resp?.body);
      if (resp != null) {

        if (resp.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(resp.body);
          setState(() => 
            messages = jsonList.map((e) => Chatcontent.fromJson(e)).toList()
          );
        }
      }
      else {
        //Failed to request from server
      }
    }
    catch (e) {
      print("hiba.");
      print(e);
    }
  }

  String _getUsername(ChatPartnerDto chatPartner) {
    return "${chatPartner.firstName} ${chatPartner.middleName} ${chatPartner.lastName}";
  }


  @override
  Widget build(BuildContext context) {
    
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var selectedIndex = 0;
    MenuItem? selectedMenu = MenuItem.itemOne;

    //print("Received info: $value");

    return GradientScaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: SafeArea(
            child: AppBar(          
                backgroundColor: themeNotifier.getAppBarColor(),
                excludeHeaderSemantics: true,
                //centerTitle: true,
                elevation: 8,
                leading: 
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: themeNotifier.getSubtitleColor(),
                      onPressed: () => Navigator.pop(context),
                    ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: 
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage('assets/blank_profile_pic.png'),                    
                        ),
                      ),
                      const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              Text(
                                _getUsername(chatPartner),
                                style: TextStyle(
                                  color: themeNotifier.getTextColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Online",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                    ],              
                  ),
                  
                ),

                
            
              actions: [
                Container(
                  decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(50) ,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.green,
                    ),
                    BoxShadow(
                      color: Colors.white70,
                      spreadRadius: -5.0,
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Camera pressed!");
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.transparent, // gomb színe
                      elevation: 0, // kikapcsoljuk az alap elevation-t
                      padding: const EdgeInsets.all(6),
                    ),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          constraints: const BoxConstraints.expand(), // teljes képernyő
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessengerCard(content: messages[index]);
                },
              )),
              const MyTextField()
            ],
          ),
        ));
  }
}

class MessengerCard extends StatelessWidget {
  final Chatcontent content;

  const MessengerCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
        title: Wrap(children: [
          Row(
            mainAxisAlignment: content.isAuthor
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4],
                    colors: [
                      Color.fromARGB(179, 231, 229, 255),
                      Color.fromARGB(179, 105, 99, 165),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  //color: Colors.transparent,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(60, 0, 0, 196), spreadRadius: 1),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 7.0),
                  child: Text(content.message),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

//Widget to display user's avatar
class UserAvatar extends StatelessWidget {
  final String userAvatar;

  const UserAvatar({super.key, required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: userAvatar.isNotEmpty
              ? NetworkImage(
                  "https://storage.googleapis.com/socialstream/$userAvatar")
              : const AssetImage('assets/blank_profile_pic.png')
                  as ImageProvider,
          fit: BoxFit.contain,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: const Color(0xff7c94b6),
          width: 1.0,
        ),
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
        color: const Color.fromARGB(255, 82, 73, 161),
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration:
                  BoxDecoration(gradient: themeNotifier.getTextBoxHeader()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      padding: const EdgeInsets.all(0.0),
                      iconSize: 20.0,
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        throw UnimplementedError("Microphone recording not yet implemented");
                      },
                      color: themeNotifier.theme == "dark"
                          ? Colors.white
                          : Colors.black),
                  IconButton(
                      padding: const EdgeInsets.all(0.0),
                      iconSize: 20.0,
                      icon: const Icon(Icons.image),
                      onPressed: () {
                        throw UnimplementedError("Image sending not yet implemented");
                      },
                      color: themeNotifier.theme == "dark"
                          ? Colors.white
                          : Colors.black),
                  IconButton(
                    padding: const EdgeInsets.all(10.0),
                    iconSize: 20.0,
                    icon: const Icon(Icons.emoji_emotions),
                    color: themeNotifier.theme == "dark"
                        ? Colors.white
                        : Colors.black,
                    onPressed: () {
                      throw UnimplementedError("Emoji sending not yet implemented");
                    },
                  ),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                spreadRadius: 0.4)
                          ]),
                      child: TextField(
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            fillColor: const Color.fromARGB(179, 67, 68, 105),
                            isDense: true,
                            counterText: "",
                            contentPadding: const EdgeInsets.all(10.0),
                            filled: true,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              color: Colors.black,
                              iconSize: 20.0,
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none)),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        maxLength: 20,
                      )),
                ),
              ),
            ])
          ],
        ));
  }
}
