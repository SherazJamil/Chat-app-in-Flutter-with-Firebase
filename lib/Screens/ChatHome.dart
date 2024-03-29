import 'package:chat_app/Authentication%20Methods/Methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Conversation.dart';

class Chathome extends StatefulWidget {
  const Chathome({Key? key}) : super(key: key);

  @override
  State<Chathome> createState() => _ChathomeState();
}

class _ChathomeState extends State<Chathome> {
  Map<String, dynamic>? userMap;
  final searchEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await  firestore.collection('users').where('email', isEqualTo: searchEditingController.text)
        .get().then((value) {
          setState(() {
            userMap = value.docs[0].data();
            isLoading = false;
          });
          print(userMap);
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        elevation: 20,
        title: const Text(
          'Mi Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<MenuItem>(
              onSelected: (value){
                if(value == MenuItem.item1){}
                if(value == MenuItem.item2){}
              },
              itemBuilder: (context) => [
             PopupMenuItem(
                value: MenuItem.item1,
                child: const Text('Settings'),
               onTap: () {},
            ),
                PopupMenuItem(
              value: MenuItem.item2,
              child: const Text('Log Out'),
              onTap: () => LogOut(context),
            )
          ])
        ],
      ),
      body: isLoading
          ? Center(
        child: Container(
          height: size.height / 20,
          width: size.height / 20,
          child: const SpinKitChasingDots(
            color: Colors.deepOrange,
          ),
        ),
      )
          : ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: searchEditingController,
                  decoration: InputDecoration(
                      hintText: "Search here...",
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.black,
                        size: 20,
                      ),
                      suffixIcon:  IconButton(
                        color: Colors.white38,
                        onPressed: () {
                          onSearch();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.black,
                          size: 20,
                        ),),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              userMap != null ? ListTile(
                minVerticalPadding: 25,
                tileColor: Colors.deepOrangeAccent,
                leading: const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/Thor.png'),
                ),
                title: Text(
                  userMap!['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                subtitle: Text(
                  userMap!['email'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(FontAwesomeIcons.solidMessage,
                  color: Colors.white,),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  String roomId = chatRoomId(
                      auth.currentUser!.displayName!,
                      userMap!['name']);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                        chatRoomId: roomId,
                        userMap: userMap!,
                      ),
                    ),
                  );
                },
              )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum MenuItem {
  item1,
  item2
}