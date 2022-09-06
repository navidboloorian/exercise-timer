import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class BottomBar extends StatelessWidget {
  // track the current page
  // passed down from main app widget
  final int currentIndex;
  final Function setCurrentIndex;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.setCurrentIndex,
  });

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
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => setCurrentIndex(index),
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: CustomColors.darkBackground,
      items: barItems,
    );
  }
}
