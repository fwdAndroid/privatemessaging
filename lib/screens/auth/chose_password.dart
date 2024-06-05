import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatemessaging/screens/auth/auth_setup.dart';
import 'package:privatemessaging/screens/dashboard/main_dashboard.dart';

class ChosePassword extends StatefulWidget {
  const ChosePassword({super.key});

  @override
  State<ChosePassword> createState() => _ChosePasswordState();
}

class _ChosePasswordState extends State<ChosePassword> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool passwordVisible = false;
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
              margin: EdgeInsets.only(left: 10, top: 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Login",
                  style: GoogleFonts.podkova(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "Enter Name",
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
                  controller: _emailController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      hintText: "Enter Your Name",
                      hintStyle: GoogleFonts.archivo(
                          fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 15),
              child: Text(
                "Password",
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
                    obscureText: passwordVisible,
                    controller: _passController,
                    decoration: InputDecoration(
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
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Enter Your Password",
                        hintStyle: GoogleFonts.archivo(
                            fontSize: 16, color: Colors.white))),
              ),
            ),
            Flexible(child: Container()),
            Center(
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
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Name is Required")));
                        } else if (_passController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Password is Required")));
                        } else {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email:
                                        _emailController.text + "@example.com",
                                    password: _passController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MainDashBoard()));
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Wrong Name and Password" ??
                                    "Login failed")));
                          }
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AuthSetup()));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Color(0xff800000),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
