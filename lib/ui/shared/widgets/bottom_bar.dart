import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static const List<IconButton> _pages = <IconButton>[
    IconButton(
      onPressed: null,
      icon: Icon(
        Icons.fitness_center,
        color: Colors.white,
      ),
    ),
    IconButton(
      onPressed: null,
      icon: Icon(
        Icons.timer,
        color: Colors.white,
      ),
    ),
    IconButton(
      onPressed: null,
      icon: Icon(
        Icons.public,
        color: Colors.white,
      ),
    ),
  ];

  static const List<BottomNavigationBarItem> _pageIcons =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.timer),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center),
      label: 'Fitness',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.public),
      label: 'Here',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: _pages,
    );
  }
}
