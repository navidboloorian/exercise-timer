import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BottomBar extends StatefulWidget {
  final List<String> pages;

  const BottomBar({super.key, required this.pages});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    // map icons to simply names
    const Map<String, IconData> icons = <String, IconData>{
      'exercises': Icons.fitness_center,
      'routines': Icons.timer,
      'market': Icons.public,
    };

    List<BottomNavigationBarItem> barItems = <BottomNavigationBarItem>[];

    // creates list of navigation bar buttons
    for (String name in icons.keys) {
      barItems.add(
        BottomNavigationBarItem(
          label: name,
          icon: Icon(
            icons[name],
            color: Colors.white,
          ),
        ),
      );
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) => Navigator.pushReplacementNamed(
        context,
        widget.pages[index],
      ),
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: CustomColors.darkBackground,
      items: barItems,
    );
  }
}
