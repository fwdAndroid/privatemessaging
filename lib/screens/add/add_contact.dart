import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatemessaging/screens/dashboard/main_dashboard.dart';
import 'package:uuid/uuid.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  TextEditingController _phoneController = TextEditingController();

  bool isLoading = false;

  var uuid = Uuid().v4();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Add Contact ID",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/save.png"),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "Add ID",
                style: GoogleFonts.archivo(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _phoneController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "ID",
                        hintStyle: GoogleFonts.archivo(
                            fontSize: 16, color: Colors.white))),
              ),
            ),
            Flexible(child: Container()),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 22),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff800000),
                              fixedSize: Size(342, 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () async {
                            if (_phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("ID Name is Required")));
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('contacts')
                                  .doc(uuid)
                                  .set({
                                "uuid": uuid,
                                "id": _phoneController.text,
                                "uid": FirebaseAuth.instance.currentUser!.uid
                              });
                              setState(() {
                                isLoading = false;
                              });
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MainDashBoard()));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(_phoneController.text +
                                    "Unique ID is Generated")));
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  )
          ],
        ),
      ),
    );
  }
}
