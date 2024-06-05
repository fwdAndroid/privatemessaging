import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatemessaging/screens/dashboard/chat_page_detail.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/cc.png",
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/save.png"),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("uid",
                  isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = (snapshot.data as QuerySnapshot?)?.docs ??
                <QueryDocumentSnapshot>[];

            if (documents.isEmpty) {
              return const Center(
                child: Text(
                  "No Friend Found yet",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>?;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(data != null
                              ? data['photoURL'].toString() ?? ""
                              : ""),
                        ),
                      ),
                      Text(
                        data != null ? data['name'] ?? "" : "",
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, snapshot) {
                          final docs =
                              (snapshot.data as QuerySnapshot?)?.docs ??
                                  <QueryDocumentSnapshot>[];
                          final datas = docs.isNotEmpty
                              ? docs[index].data() as Map<String, dynamic>?
                              : null;
                          return TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => ChatPageDetail(
                                    friendId:
                                        data != null ? data['uid'] ?? "" : "",
                                    friendName:
                                        data != null ? data['name'] ?? "" : "",
                                    friendPhoto: data != null
                                        ? data['photoURL'] ?? ""
                                        : "",
                                    userId:
                                        datas != null ? datas['uid'] ?? "" : "",
                                    userPhoto: datas != null
                                        ? datas['photoURL'] ?? ""
                                        : "",
                                    userName: datas != null
                                        ? datas['name'] ?? ""
                                        : "",
                                  ),
                                ),
                              );
                            },
                            child: Text("Chat Now"),
                          );
                        },
                      ),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
