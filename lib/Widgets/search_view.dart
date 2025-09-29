import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next page'),
      ),
      body: Container(
        height: double.infinity,
            padding: const EdgeInsets.only(top: 0.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black54,
                    /*AppColours.appgradientfirstColour,
                    AppColours.appgradientsecondColour*/
                  ],
                  
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: const ListTile(
                  subtitle: Text("This is Dummy Data",style: TextStyle(
                    color: Colors.white
                  ),),
                  title: Text("Hello World",style: TextStyle(
                      color: Colors.white
                  ),),
                )),
          ),
    );
  }
}
