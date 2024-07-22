import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_chat/Models/ChatContent.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

enum MenuItem { itemOne, itemTwo, itemThree }

class _MessageViewState extends State<MessageView> {
  Map<Map<String, dynamic>, Map<String, dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments
        as Map<Map<String, dynamic>, Map<String, dynamic>>;

    Map<String, dynamic> key = data.keys.elementAt(0);
    Map<String, dynamic> value = data[key]!;
    var chatContents = key['chatContents'];
    var selectedIndex = 0;
    MenuItem? selectedMenu;

    print("Received content: $chatContents");
    //print("Received info: $value");

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue[400],
            centerTitle: true,
            title: Text(
                "${value['firstName']} ${value['middleName']} ${value['lastName']}"),
            actions: <Widget>[
              // Builder(
              //   builder: (context) {
              //     return IconButton(
              //       icon: const Icon(Icons.more_vert),
              //       onPressed: () {
              //         if (more_options.isOpen) {
              //           more_options.close();
              //         } else {
              //           more_options.open();
              //         }
              //       },
              //     );
              //   },
              // ),
              MenuAnchor(
                builder: (BuildContext context, MenuController controller,
                    Widget? child) {
                  return IconButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                    tooltip: 'Show menu',
                  );
                },
                menuChildren: List<MenuItemButton>.generate(
                  3,
                  (int index) => MenuItemButton(
                    onPressed: () =>
                        setState(() => selectedMenu = MenuItem.values[index]),
                    child: Text('Item ' + selectedIndex.toString()),
                  ),
                ),
              ),
            ]),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF39B0D2), Color(0xFF8277EE)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, -1),
              end: AlignmentDirectional(0, 1),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemCount: chatContents.length,
                itemBuilder: (context, index) {
                  return MessengerCard(
                      avatar: value['avatar'],
                      content: Chatcontent.fromJson(chatContents[index]));
                },
              )),
              Container(
                  color: const Color.fromARGB(88, 98, 90, 170),
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 0.4, 0.9],
                          colors: [
                            Color.fromARGB(87, 231, 229, 255),
                            Color.fromARGB(88, 98, 90, 170),
                            Color.fromARGB(87, 231, 229, 255),
                          ],
                        )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 20.0,
                                icon: const Icon(Icons.mic),
                                onPressed: () {
                                  print("microphone recording");
                                },
                                color: Colors.black),
                            IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 20.0,
                                icon: const Icon(Icons.image),
                                onPressed: () {
                                  print("image sending");
                                },
                                color: Colors.black),
                            IconButton(
                              padding: EdgeInsets.all(10.0),
                              iconSize: 20.0,
                              icon: const Icon(Icons.emoji_emotions),
                              color: Colors.black,
                              onPressed: () {
                                print("emoji sending");
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                fillColor: Color.fromARGB(255, 119, 121, 238),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.black,
                          iconSize: 20.0,
                          onPressed: () {},
                        )
                      ])
                    ],
                  )),
            ],
          ),
        ));
  }
}

class MessengerCard extends StatelessWidget {
  final String avatar;
  final Chatcontent content;

  const MessengerCard({super.key, required this.avatar, required this.content});

  bool MessageIsFromUser(id) {
    return id == 1491; //TOdo: get userId from storage
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
        leading: !MessageIsFromUser(content.AuthorId)
            ? UserAvatar(userAvatar: avatar)
            : null,
        trailing: MessageIsFromUser(content.AuthorId)
            ? UserAvatar(userAvatar: avatar)
            : null,
        title: Wrap(children: [
          Row(
            mainAxisAlignment: MessageIsFromUser(content.AuthorId)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(60, 0, 0, 196), spreadRadius: 3),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 7.0),
                  child: Text(content.Message),
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

  const UserAvatar({required this.userAvatar});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: userAvatar.isNotEmpty
          ? NetworkImage(
              "https://storage.googleapis.com/socialstream/$userAvatar")
          : const AssetImage('assets/blank_profile_pic.png') as ImageProvider,
    );
  }
}
