import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app/controller/bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomNav extends StatelessWidget {
  MyBottomNav({super.key});
  final icons = [
    Icons.home,
    Icons.assessment,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      splashColor: Colors.teal.shade300,
      splashRadius: 30,
      itemCount: icons.length,
      backgroundColor: Colors.teal.shade50,
      leftCornerRadius: 20,
      rightCornerRadius: 20,
      tabBuilder: (index, isActive) {
        return Icon(
          icons[index],
          size: 25,
        );
      },
      gapLocation: GapLocation.none,
      activeIndex: Provider.of<BottomNotifier>(context).counter,
      onTap: (newIndex) {
        Provider.of<BottomNotifier>(context, listen: false)
            .changeIndex(newIndex);
      },
    );
  }
}
