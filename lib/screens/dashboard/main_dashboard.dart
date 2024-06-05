import 'package:flutter/material.dart';
import 'package:privatemessaging/screens/dashboard/chat_page.dart';
import 'package:privatemessaging/screens/dashboard/contacts.dart';
import 'package:privatemessaging/screens/dashboard/profile.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({super.key});

  @override
  State<MainDashBoard> createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ChatPage(),
    Contacts(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? Container(
                    padding: EdgeInsets.all(8),
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Color(0xff337af6),
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.chat_bubble,
                    color: Colors.white,
                  ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Container(
                    padding: EdgeInsets.all(8),
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Color(0xff337af6),
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
              label: "Profile",
              icon: _currentIndex == 2
                  ? Container(
                      padding: EdgeInsets.all(8),
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Color(0xff337af6),
                          borderRadius: BorderRadius.all(Radius.circular(60))),
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.person_pin,
                      color: Colors.white,
                    )),
        ],
        selectedItemColor: Color(0xff337af6),
        unselectedItemColor: Colors.white,
        backgroundColor:
            Color(0xff50556b), // Set your desired background color here
      ),
    );
  }
}
