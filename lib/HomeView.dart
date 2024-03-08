import 'package:flutter/material.dart';
import 'Models/ChatRoom.dart';
import 'Models/User.dart';
import 'Models/UserInfo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //Map userData = {};
  //late Map chatRooms;
  Map<Map<String, dynamic>, Map<String, dynamic>> mappedData = {};

  @override
  Widget build(BuildContext context) {
    //userData = ModalRoute.of(context)!.settings.arguments as Map;
    //chatRooms = ModalRoute.of(context)!.settings.arguments as Map;
    mappedData = ModalRoute
        .of(context)!
        .settings
        .arguments
    as Map<Map<String, dynamic>, Map<String, dynamic>>;


    return Scaffold(
        body:
        Column(
          children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SafeArea(
                  child: SizedBox(
                      width: 100.0,
                    child: Text(
                      "Chatek",
                      style: TextStyle(fontSize: 18),
                    )),
                ),
              ],
            ),
          ),
        Expanded(
            child:
            ListView.builder(
              itemCount: mappedData.keys.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> key = mappedData.keys.elementAt(index);
                Map<String, dynamic> value = mappedData[key]!;

                var userAvatar = value['avatar'].toString();
                var chatContents = key['chatContents'];

                //print(chatContents[0]);
                return Card(
                    child: ListTile(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/messages', arguments: mappedData);
                      },
                      leading: CircleAvatar(
                        backgroundImage: userAvatar.isNotEmpty
                            ?
                        NetworkImage(
                            "https://storage.googleapis.com/socialstream/$userAvatar")
                            :
                        const AssetImage(
                            'assets/blank_profile_pic.png') as ImageProvider,
                      ),
                      title: Text("${chatContents[0]['message']}"),
                      subtitle: Text("${chatContents[0]['sentDate']}"),
                      trailing: const Icon(
                        Icons.circle_rounded,
                        color: Colors.green,
                      ),

                    ));
              },
            )
        )
    ]
    ));
  }
}
