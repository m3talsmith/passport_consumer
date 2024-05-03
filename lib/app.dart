import 'dart:developer';

import 'package:flutter/material.dart';

import 'scanner/page.dart';
import 'sites/page.dart';

class GeneralApp extends StatefulWidget {
  const GeneralApp({super.key});

  @override
  State<StatefulWidget> createState() => _GeneralAppState();
}

class _GeneralAppState extends State<GeneralApp> {
  final List<Widget> _pages = [const ScannerPage(), const SitesPage()];

  int _selectedPage = 0;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return MaterialApp(
      title: 'Passport',
      debugShowCheckedModeBanner: false,
      theme: _darkMode
          ? ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                background: Colors.deepPurple,
                surface: Colors.deepPurple,
                secondary: Colors.deepOrangeAccent,
                brightness: Brightness.dark,
              ),
              useMaterial3: true)
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrange,
                secondary: Colors.deepPurple,
                tertiary: Colors.lightGreen,
                brightness: Brightness.light
              ),
              useMaterial3: true),
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            Row(
              children: [
                const Icon(Icons.nightlight_round),
                Switch(
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                  inactiveThumbColor: Theme.of(context).hintColor,
                  trackColor: MaterialStatePropertyAll(
                      _darkMode
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).splashColor
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
              icon: const Icon(Icons.settings_rounded),
            )
          ],
        ),
        body: _pages[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selectedPage = value;
            });
          },
          currentIndex: _selectedPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner_rounded, size: 50),
                label: 'Login',
                tooltip: 'Scanner to log into sites'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.web_stories_rounded,
                  size: 50,
                ),
                label: 'Sites',
                tooltip: 'Sites that you have logged into in the past')
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              const Column(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              const Divider(
                indent: 32,
                endIndent: 32,
              ),
              ListTile(
                title: const Text('Restore User'),
                trailing: const Icon(Icons.restore_rounded),
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
