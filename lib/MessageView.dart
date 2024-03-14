import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalr_chat/Models/ChatContent.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  Map<Map<String, dynamic>, Map<String, dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments
    as Map<Map<String, dynamic>, Map<String, dynamic>>;

    Map<String, dynamic> key = data.keys.elementAt(0);
    Map<String, dynamic> value = data[key]!;
    var chatContents = key['chatContents'];

    print("Received content: $chatContents");
    //print("Received info: $value");

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue[400],
          centerTitle: true,
          title: Text(
        "${value['firstName']} ${value['middleName']} ${value['lastName']}")

        ),
        body: Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
        itemCount: chatContents.length,
        itemBuilder: (context, index) {
          return MessengerCard(avatar: value['avatar'],
              content: Chatcontent.fromJson(chatContents[index]));
        },
      )),
      Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            child: TextFormField(
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: "Some Text",
                labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                fillColor: Colors.blue,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 20.0,
            onPressed: () {},
          )
        ]),
      ),
    ]));
  }
}

class MessengerCard extends StatelessWidget {
  final String avatar;
  final Chatcontent content;

  const MessengerCard({
    super.key,
    required this.avatar,
    required this.content
  });

  bool MessageIsFromUser(id) {
    return id == 1491; //TOdo: get userId from storage
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero),
      elevation: 0,
      child: ListTile(
        leading: !MessageIsFromUser(content.AuthorId) ? UserAvatar(userAvatar: avatar) : null,
        trailing: MessageIsFromUser(content.AuthorId) ? UserAvatar(userAvatar: avatar) : null,
        title:
        Wrap(
            children: [
              Row(
                mainAxisAlignment: MessageIsFromUser(content.AuthorId) ?
                        MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      boxShadow: const [
                        BoxShadow(color: Color.fromARGB(60, 0, 0, 196), spreadRadius: 3),
                      ],
                    ),
                    child:
                    Padding(
                      padding:
                      const EdgeInsets.symmetric
                        (vertical: 10.0, horizontal: 7.0),
                      child: Text('${content.Message}'),
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

  const UserAvatar({
  required this.userAvatar
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: userAvatar.isNotEmpty
          ?
      NetworkImage(
          "https://storage.googleapis.com/socialstream/$userAvatar")
          :
      const AssetImage(
          'assets/blank_profile_pic.png') as ImageProvider,
    );
  }
}
