import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatemessaging/screens/auth/chose_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController providerPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Forgot password,",
                style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please type your name  below and we will give you a OTP code,",
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Flexible(child: Container()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: providerPassController,
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
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff800000),
                        fixedSize: Size(342, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text(
                      "Send Code",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (providerPassController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("NAme is Required")));
                      } else {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: providerPassController.text +
                                    "@example.com")
                            .then((value) => {
                                  FirebaseAuth.instance.signOut(),
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              ChosePassword()))
                                });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Email verification link is sent")));
                      }
                    }),
              ),
            ),
            Flexible(child: Container()),
          ],
        ),
      ),
    );
  }
}
