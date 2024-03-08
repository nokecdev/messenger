import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    var userAvatar = value['avatar'].toString();
    var chatContents = key['chatContents'];

    //print("Received content: $");
    //print("Received info: $value");

    return Scaffold(
        body: Column(children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.0),
                  //Header
                  Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        const SizedBox(height: 4.0),
                        UserAvatar(userAvatar: userAvatar),
                        const SizedBox(height: 8.0,),
                        Container(
                          height: 40.0,
                          child:
                              Flexible(
                                child: Text(
                                "${value['firstName']} ${value['middleName']} ${value['lastName']}",
                                style: TextStyle(fontSize: 18),
                              )),
                          )
                      ],
                    ),
                  ),
                ],
            ),
            )]
          ),
        ),

      Expanded(
          child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return MessageCard(
              leading: value['avatar'],
              title: chatContents[index]['message']);
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

class MessageCard extends StatelessWidget {
  final String leading;
  final String title;

  const MessageCard({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero),
      elevation: 0,
      child: ListTile(
        leading: UserAvatar(userAvatar: leading),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.lightBlueAccent,
            child: Text('$title'),
          ),
        ),
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
