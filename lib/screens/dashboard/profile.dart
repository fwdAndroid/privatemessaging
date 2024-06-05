import 'package:flutter/material.dart';
import 'package:privatemessaging/screens/add/add_contact.dart';
import 'package:privatemessaging/screens/dashboard/setting_page.dart';
import 'package:privatemessaging/screens/security/app_lock.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/cc.png",
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
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AddContacts()));
              },
              leading: Icon(
                Icons.addchart_outlined,
                color: Color(0xff800000),
              ),
              title: Text(
                "Add Contact",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(.5),
            ),

            // ListTile(
            //   leading: Icon(
            //     Icons.format_quote,
            //     color: Color(0xff800000),
            //   ),
            //   title: Text(
            //     "FAQ",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // Divider(
            //   color: Colors.grey.withOpacity(.5),
            // ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => SettingPage()));
              },
              leading: Icon(
                Icons.password,
                color: Color(0xff800000),
              ),
              title: Text(
                "Change Password",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(.5),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (builder) => AppLockScreen()));
              },
              leading: Icon(
                Icons.lock,
                color: Color(0xff800000),
              ),
              title: Text(
                "App Lock",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(.5),
            )
          ],
        ),
      ),
    );
  }
}
