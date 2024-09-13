import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class ChatPageDetail extends StatefulWidget {
  final String userId;
  final String userName;
  final String friendId;
  final String friendName;
  final String friendPhoto;
  final String userPhoto;

  const ChatPageDetail({
    Key? key,
    required this.userPhoto,
    required this.friendPhoto,
    required this.friendId,
    required this.friendName,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPageDetail> createState() => _ChatPageDetailState();
}

class _ChatPageDetailState extends State<ChatPageDetail> {
  String groupChatId = "";
  ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  File? imageUrl;
  UploadTask? task;
  File? file;

  bool isMasked = false;
  int selectedDuration = 0; // Initial duration selection
  bool hideExpandedWidget = false;
  Timer? hideTimer; // Timer variable to keep track of hiding duration

  TextEditingController messageController = TextEditingController();
  String? imageLink, fileLink;
  firebase_storage.UploadTask? uploadTask;

  //Inactive
  bool isScreenActive = true; // Track screen activity
  // Timer to toggle font back to normal after screen inactivity
  late Timer toggleFontTimer;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    if (FirebaseAuth.instance.currentUser!.uid.hashCode <=
        widget.friendId.hashCode) {
      groupChatId =
          "${FirebaseAuth.instance.currentUser!.uid}-${widget.friendId}";
    } else {
      groupChatId =
          "${widget.friendId}-${FirebaseAuth.instance.currentUser!.uid}";
    }
    toggleFontTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        isScreenActive = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    hideTimer?.cancel(); // Cancel the timer when widget is disposed
    toggleFontTimer.cancel(); // Cancel the timer when widget is disposed
    scrollController.dispose();
  }

  void scrollToBottom() {
    // Scroll to the bottom of the ListView
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 2),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userPhoto),
                  maxRadius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.userName,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: selectedDuration,
                  dropdownColor: Colors.black,
                  icon: Icon(Icons.timer, color: Colors.white),
                  items: [
                    DropdownMenuItem(
                        value: 10,
                        child:
                            Text('10s', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 30,
                        child:
                            Text('30s', style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 60,
                        child: Text('1 min',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 3600,
                        child: Text('1 hour',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 28800,
                        child: Text('8 hours',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 86400,
                        child: Text('1 day',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 604800,
                        child: Text('1 week',
                            style: TextStyle(color: Colors.white))),
                    DropdownMenuItem(
                        value: 0,
                        child: Text('Permanently',
                            style: TextStyle(color: Colors.white))),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value!;
                      if (selectedDuration > 0) {
                        hideExpandedWidget = true;
                        // Start a timer to unhide the widget after selected duration
                        hideTimer =
                            Timer(Duration(seconds: selectedDuration), () {
                          setState(() {
                            hideExpandedWidget = false;
                          });
                        });
                      } else {
                        hideExpandedWidget = false;
                        hideTimer?.cancel(); // Cancel any ongoing timer
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chat.png"),
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isEmpty
                      ? Center(child: Text("Empty"))
                      : Visibility(
                          visible:
                              !hideExpandedWidget, // Use the boolean to control visibility

                          child: Expanded(
                            child: ListView.builder(
                              reverse: false,
                              controller: scrollController,
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              itemBuilder: (context, index) {
                                var ds = snapshot.data!.docs[index];
                                bool isSender = ds.get("senderId") ==
                                    FirebaseAuth.instance.currentUser!.uid;
                                String messageId = ds.id;

                                return ds.get("type") == 0
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: Align(
                                          alignment: isSender
                                              ? Alignment.bottomRight
                                              : Alignment.bottomLeft,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: isSender
                                                  ? Colors.grey.shade100
                                                  : Colors.blue[100],
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ds.get("content"),
                                                ),
                                                Text(
                                                  DateFormat.jm().format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                      int.parse(ds.get("time")),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : ds.get("type") == 1
                                        ? Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 10,
                                                        bottom: 10),
                                                    child: Align(
                                                      alignment: isSender
                                                          ? Alignment
                                                              .bottomRight
                                                          : Alignment
                                                              .bottomLeft,
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              height: 140,
                                                              imageUrl: ds
                                                                  .get("image"),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  new CircularProgressIndicator(),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  new Icon(Icons
                                                                      .error),
                                                            ),
                                                            Text(
                                                              DateFormat.jm()
                                                                  .format(
                                                                DateTime
                                                                    .fromMillisecondsSinceEpoch(
                                                                  int.parse(ds.get(
                                                                      "time")),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  task != null
                                                      ? buildUploadStatus(task!)
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container();
                              },
                            ),
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff1f2c34),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: messageController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8, top: 10),
                            suffixIcon:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: addFile,
                                  icon: Icon(Icons.attach_file)),
                              IconButton(
                                  onPressed: addImage,
                                  icon: Icon(Icons.camera_alt)),
                            ]),
                            hintText: "Message",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        sendMessage(messageController.text.trim(), 0);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      backgroundColor: Colors.black,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String content, int type) {
    if (content.trim() != '') {
      messageController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.friendId,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
          },
        );
      }).then((_) {
        // Refresh messages after sending
        scrollToBottom();
      });

      scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Container();
          }
        },
      );

  Future uploadImageToFirebase() async {
    File? fileName = imageUrl;
    var uuid = Uuid();
    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(
            'messages/${FirebaseAuth.instance.currentUser!.uid}/images+${uuid.v4()}');
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(fileName!);
    firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() async {
      String img = await uploadTask.snapshot.ref.getDownloadURL();
      setState(() {
        imageLink = img;
      });
    });
  }

  void addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageUrl = File(image!.path);
    });
    await uploadImageToFirebase().then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.friendId,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'image': imageLink,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': 1,
          },
        );
      });
    }).then((value) {
      messageController.clear();
    });
  }

  void addFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageUrl = File(image!.path);
    });
    await uploadImageToFirebase().then((value) {
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.friendId,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'image': imageLink,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': 1,
          },
        );
      });
    }).then((value) {
      messageController.clear();
    });
  }
}
