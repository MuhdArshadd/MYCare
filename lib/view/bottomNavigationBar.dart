import 'package:flutter/material.dart';
import 'homePage.dart';
import 'newsPage.dart';
import 'supportServicePage.dart';
import 'forumPage.dart';

class BottomNavWrapper extends StatefulWidget {
  final int currentIndex;

  const BottomNavWrapper({super.key, required this.currentIndex});

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewsPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SupportServicePage()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForumPage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
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
        borderRadius: const BorderRadius.only(
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
          items: const [
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
