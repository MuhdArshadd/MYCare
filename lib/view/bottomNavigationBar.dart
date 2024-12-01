import 'package:flutter/material.dart';
import 'homePage.dart';
import 'newsPage.dart';
import 'supportServicePage.dart';

class BottomNavWrapper extends StatefulWidget {
  final int currentIndex;

  const BottomNavWrapper({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavWrapperState createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SupportServicePage()));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),

        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[400], // Background color matching HomePage
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: _onTabSelected,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support),
              label: 'Support Service',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Forum',
            ),
          ],
        ),
      ),
    );
  }
}
