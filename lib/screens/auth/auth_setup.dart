import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privatemessaging/screens/auth/chose_password.dart';
import 'package:privatemessaging/screens/services/auth_services.dart';
import 'package:privatemessaging/utils/utils.dart';

class AuthSetup extends StatefulWidget {
  const AuthSetup({super.key});

  @override
  State<AuthSetup> createState() => _AuthSetupState();
}

class _AuthSetupState extends State<AuthSetup> {
  TextEditingController _pass = TextEditingController();
  TextEditingController name = TextEditingController();
  bool passwordVisible = false;
  Uint8List? _image;

  //Looding Variable
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
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
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 59, backgroundImage: MemoryImage(_image!))
                          : CircleAvatar(
                              radius: 59,
                              backgroundImage: NetworkImage(
                                  'https://www.shareicon.net/data/128x128/2016/08/18/809259_user_512x512.png'),
                            ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: name,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Enter Name",
                        hintStyle: GoogleFonts.archivo(
                            fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    obscureText: passwordVisible,
                    controller: _pass,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Enter Password",
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        hintStyle: GoogleFonts.archivo(
                            fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Padding(
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
                                if (_image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Image  is Required")));
                                } else if (name.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Name is Required")));
                                } else if (_pass.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Password is Required")));
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await AuthMethods().signUpUser(
                                      pass: _pass.text,
                                      name: name.text,
                                      file: _image!);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              ChosePassword()));
                                }
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ChosePassword()));
                  },
                  child: Text(
                    "Sign IN",
                    style: TextStyle(color: Color(0xff800000)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Select Image From Gallery
  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }
}
