import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatemessaging/screens/auth/chose_password.dart';
import 'package:privatemessaging/screens/dashboard/main_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinVerificationScreen extends StatefulWidget {
  @override
  _PinVerificationScreenState createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController _controller = TextEditingController();
  int _attempts = 0;
  bool _isLocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Verify Pin',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/save.png"),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    controller: _controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter 4 Digit Pin",
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLocked ? null : _verifyPin,
                    child: Text(
                      "Verify Pin",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff800000)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final correctPin = prefs.getString('pin');
    String enteredPin = _controller.text;

    if (enteredPin == correctPin) {
      bool isAuthenticated = await _checkIfAuthenticated();
      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainDashBoard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChosePassword()),
        );
      }
    } else {
      setState(() {
        _attempts++;
      });

      if (_attempts >= 4) {
        setState(() {
          _isLocked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Too many attempts. Please wait 30 seconds.'),
          backgroundColor: Colors.red,
        ));
        await Future.delayed(Duration(seconds: 30));
        setState(() {
          _attempts = 0;
          _isLocked = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong Pin. Attempt $_attempts of 4.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<bool> _checkIfAuthenticated() async {
    // Check if a user is authenticated with Firebase
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
