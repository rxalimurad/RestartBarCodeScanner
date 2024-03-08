import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_scanner/ProductsList/ProductsListController.dart';

import '../ProductsList/ProductsListScreen.dart';


class MyHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'route': '/',
    },
    {
      'title': 'Categories',
      'icon': Icons.category,
      'submenu': [
        {'title': 'Classroom Furniture', 'route': '/classroom-furniture'},
        {'title': 'Teaching Resources', 'route': '/teaching-resources'},
        {'title': 'Classroom Decorations', 'route': '/classroom-decorations'},
        {'title': 'Arts & Crafts', 'route': '/arts-and-crafts'},
        {'title': 'Books', 'route': '/books'},
        {'title': 'Language', 'route': '/language'},
        {'title': 'Math', 'route': '/math'},
        {'title': 'Science', 'route': '/science'},
        {'title': 'STEM', 'route': '/stem'},
        {'title': 'Social Studies', 'route': '/social-studies'},
        {'title': 'Infants & Toddlers', 'route': '/infants-and-toddlers'},
        {'title': 'Blocks & Manipulatives', 'route': '/blocks-and-manipulatives'},
        {'title': 'Dramatic Play', 'route': '/dramatic-play'},
        {'title': 'Active Play', 'route': '/active-play'},
        {'title': 'Sand & Water', 'route': '/sand-and-water'},
        {'title': 'Sensory Exploration', 'route': '/sensory-exploration'},
        {'title': 'Music', 'route': '/music'},
        {'title': 'Games', 'route': '/games'},
        {'title': 'Puzzles', 'route': '/puzzles'}
      ]

    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'route': '/settings',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('RESTART', style: TextStyle(color: Color(0xFFC00000), fontWeight: FontWeight.bold)),
              Text(' Education', style: TextStyle(color: Color(0xFF3076B5), fontWeight: FontWeight.bold))
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: ProductsListScreen()),
        drawer: Drawer(
            child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text('RESTART', style: TextStyle(color: Color(0xFFC00000), fontWeight: FontWeight.bold, fontSize: 30), ),
                  Text(' Educationall', style: TextStyle(color: Color(0xFF3076B5), fontWeight: FontWeight.bold, fontSize: 30)),
                  Text(' Foundation', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30))
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...menuItems
                      .map((item) => item['submenu'] == null
                          ? ListTile(
                              title: Text(item['title']!),
                              leading: Icon(item['icon']!),
                              onTap: () {

                              },
                            )
                          : ExpansionTile(
                              title: Text(item['title']!),
                              leading: Icon(item['icon']!),
                              children: _buildSubmenu(item['submenu']),
                            ))
                      .toList(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  List<Widget> _buildSubmenu(List<Map<String, String>> submenuItems) {
    return submenuItems
        .map((item) => ListTile(
              title: Text(item['title']!),
              onTap: () {
                Get.back();
                Get.toNamed('/all', arguments: {'category': item['title']!});
              },
            ))
        .toList();
  }
}
