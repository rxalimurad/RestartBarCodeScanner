import 'package:flutter/material.dart';

import 'ScanScreen.dart';

class MyHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'route': '/',
    },
    {
      'title': 'Products',
      'icon': Icons.shopping_cart,
      'submenu': [
        {'title': 'Electronics', 'route': '/electronics'},
        {'title': 'Clothing', 'route': '/clothing'},
        {'title': 'Books', 'route': '/books'},
      ],
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
              Text('RESTART', style: TextStyle(color: Color(0xFFC00000))),
              Text(' Education', style: TextStyle(color: Color(0xFF3076B5)))
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: ScanScreen()),
        drawer: Drawer(
            child: Column(
          children: [
            DrawerHeader(
              child: Text('RESTART Education'),
              decoration: BoxDecoration(color: Color(0xFF3076B5)),
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
                                // Navigator.pushNamed(context, item['route']);
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
                // Navigator.pushNamed(context, item['route']);
              },
            ))
        .toList();
  }
}
