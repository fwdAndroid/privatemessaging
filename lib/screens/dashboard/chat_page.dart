import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatemessaging/screens/dashboard/chat_page_detail.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

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
            fit: BoxFit.cover,
          ),
        ),
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
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(data != null
                            ? data['photoURL'].toString() ?? ""
                            : ""),
                      ),
                      subtitle: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("messages")
                            .doc(groupChatId(data!['uid']))
                            .collection(groupChatId(data['uid']))
                            .orderBy("timestamp", descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.docs.isNotEmpty) {
                            final latestMessage = snapshot.data!.docs.first
                                .data() as Map<String, dynamic>;
                            return Text(
                              latestMessage['content'],
                              style: GoogleFonts.abhayaLibre(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else {
                            return Text(
                              "No messages yet",
                              style: GoogleFonts.abhayaLibre(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                        },
                      ),
                      title: Text(
                        data != null ? data['name'] ?? "" : "",
                        style: GoogleFonts.abhayaLibre(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: StreamBuilder(
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
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String groupChatId(String userId) {
    if (FirebaseAuth.instance.currentUser!.uid.hashCode <= userId.hashCode) {
      return "${FirebaseAuth.instance.currentUser!.uid}-$userId";
    } else {
      return "$userId-${FirebaseAuth.instance.currentUser!.uid}";
    }
  }
}
