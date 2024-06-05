import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatemessaging/screens/security/reset_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  TextEditingController _controller = TextEditingController();
  bool _isPinSet = false;

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  void _checkPinStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('pin');
    setState(() {
      _isPinSet = pin != null;
    });
  }

  void _setPin() async {
    String pin = _controller.text;

    if (pin.length == 4) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pin', pin);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pin set successfully!'),
          backgroundColor: Colors.green,
        ));

        setState(() {
          _isPinSet = true;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to set pin: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pin must be 4 digits long'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _disablePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pin');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pin disabled successfully!'),
        backgroundColor: Colors.green,
      ));

      setState(() {
        _isPinSet = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to disable pin: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _isPinSet ? _disablePin : null,
            icon: Icon(
              Icons.disabled_by_default,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (builder) => ResetPin()));
            },
            icon: Icon(Icons.reset_tv, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'App Lock Screen',
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
        child: Padding(
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
                  Text(
                    "Confrim Your Pin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
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
                  ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff800000),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _setPin,
                      child: Text(
                        "Set Pin",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff800000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
