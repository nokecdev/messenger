import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/ChatContent.dart';
import 'package:signalr_chat/Widgets/States/ThemeNotifier.dart';

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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    var chatContents = key['chatContents'];
    var selectedIndex = 0;
    MenuItem? selectedMenu;

    print("Received content: $chatContents");
    //print("Received info: $value");

    return Scaffold(
        appBar: AppBar(
            backgroundColor: themeNotifier.getAppBarColor(),
            excludeHeaderSemantics: true,
            centerTitle: true,
            title: Text(
                "${value['firstName']} ${value['middleName']} ${value['lastName']}"),
            actions: <Widget>[
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
          decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
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
              MyTextField()
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
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4, 0.9],
                    colors: [
                      Color.fromARGB(179, 231, 229, 255),
                      Color.fromARGB(88, 98, 90, 170),
                      Color.fromARGB(87, 231, 229, 255),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  //color: Colors.transparent,
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
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
        color: Color.fromARGB(255, 82, 73, 161),
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
                      padding: EdgeInsets.all(0.0),
                      iconSize: 20.0,
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        print("microphone recording");
                      },
                      color: themeNotifier.theme == "dark"
                          ? Colors.white
                          : Colors.black),
                  IconButton(
                      padding: EdgeInsets.all(0.0),
                      iconSize: 20.0,
                      icon: const Icon(Icons.image),
                      onPressed: () {
                        print("image sending");
                      },
                      color: themeNotifier.theme == "dark"
                          ? Colors.white
                          : Colors.black),
                  IconButton(
                    padding: EdgeInsets.all(10.0),
                    iconSize: 20.0,
                    icon: const Icon(Icons.emoji_emotions),
                    color: themeNotifier.theme == "dark"
                        ? Colors.white
                        : Colors.black,
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
