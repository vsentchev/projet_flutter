import 'package:flutter/material.dart';

Widget buildBottomNavigationBar(int selectedIndex, Function(int) onItemTapped) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Find LittleWords',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
  
