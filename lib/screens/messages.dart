import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/chat_content.dart';
import 'package:signalr_chat/Models/chat_partner_dto.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';
import 'package:signalr_chat/Widgets/gradient_scaffold.dart';
import 'package:signalr_chat/utils/factory.dart';

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
        chatPartner = args;
      });
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
      var resp = await apiService.getChatContents(chatPartner.chatRoomId);
      if (!mounted) return;

      if (resp != null) {

        if (resp.statusCode == 200) {
          final List<dynamic> jsonList = jsonDecode(resp.body);
          setState(() => 
            messages = jsonList.map((e) => Chatcontent.fromJson(e)).toList()
          );
        }
        else {
          //TODO: Show error message
        }
      }
      else {
        //TODO: Failed to request from server, show error message
      }
    }
    catch (e) {
      print("hiba.");
      print(e);
      //TODO: Show error message
    }
  }

  String _getUsername(ChatPartnerDto chatPartner) {
    return "${chatPartner.firstName} ${chatPartner.middleName} ${chatPartner.lastName}";
  }

  Widget _getMessagesHeader() {
    return 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.3],
                colors: [Colors.white, Colors.black]
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.white,
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.video_camera_front_sharp),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.3],
                colors: [Colors.white, Colors.black]
              ),                        ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.white,
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.phone),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return GradientScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: SafeArea(
            child: AppBar(          
                backgroundColor: themeNotifier.getAppBarColor(),
                excludeHeaderSemantics: true,
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900
                                ),
                              ),
                            ],
                          ),
                    ],              
                  ),
                ),
              actions: [
                _getMessagesHeader()                
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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    
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
              gradient: themeNotifier.getTextBoxHeader(),
              borderRadius: BorderRadius.circular(3),
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
  
    )
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
        color: themeNotifier.getTextAreaColor(),
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: themeNotifier.getTextBoxHeader(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// Bal oldali +
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.white24,
                                onTap: () {},
                                child: const Center(child: Icon(Icons.add, size: 18)),
                              ),
                            ),
                          ),


                            /// Szövegmező
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: themeNotifier.getTextColor()),
                              decoration: InputDecoration(
                                hintText: "Írj valamit...",
                                hintStyle: TextStyle(color: Colors.grey.shade700),
                                border: InputBorder.none,
                                isDense: true,
                                
                                contentPadding: const EdgeInsets.all(8),
                                fillColor: Color.lerp(Colors.black, Colors.black12, 4) 
                              ),
                              maxLines: 1,
                            ),
                          ),
                          
                          /// Küldés gomb
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.white24,
                                onTap: () {},
                                child: const Center(child: Icon(Icons.send, size: 18)),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
              
                  const SizedBox(width: 8),
              
                  /// Mikrofon gomb
                  createCircleButton(24, const Icon(Icons.mic, size: 18)),

                  const SizedBox(width: 8),

                  /// Kamera gomb
                  createCircleButton(24, const Icon(Icons.camera_alt, size: 18)),
                ],
              ),
            )
          ],
        ));
  }
}
