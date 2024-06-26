import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';

import 'storage/storage.dart';
import 'scanner/page.dart';
import 'profile/page.dart';

class GeneralApp extends StatefulWidget {
  const GeneralApp({super.key});

  @override
  State<StatefulWidget> createState() => _GeneralAppState();
}

class _GeneralAppState extends State<GeneralApp> {
  final List<Widget> _pages = [const ScannerPage(), const ProfilePage()];

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    return MaterialApp(
      title: 'Passport',
      debugShowCheckedModeBanner: false,
      theme: Preferences().darkMode
          ? ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                background: Colors.deepPurple,
                surface: Colors.deepPurple,
                secondary: Colors.deepOrangeAccent,
                tertiary: Colors.deepPurple.shade900,
                brightness: Brightness.dark,
              ),
              useMaterial3: true)
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                background: Colors.white,
                secondary: Colors.blueGrey,
                tertiary: Colors.blueGrey.shade100,
                brightness: Brightness.light,
              ),
              useMaterial3: true),
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            Row(
              children: [
                const Icon(Icons.sunny),
                Switch(
                  value: Preferences().darkMode,
                  onChanged: (value) {
                    setState(() {
                      Preferences().setDarkMode(value);
                    });
                  },
                  inactiveThumbColor: Theme.of(context).hintColor,
                  trackColor: MaterialStatePropertyAll(Preferences().darkMode
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).splashColor),
                ),
                const Icon(Icons.nightlight_round),
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
                  Icons.person_rounded,
                  size: 50,
                ),
                label: 'Profile',
                tooltip: 'Your user profile information')
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
                title: const Text('Restore Passport'),
                trailing: const Icon(Icons.restore_rounded),
                onTap: () async {
                  var result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    var archive = File(result.files.single.path!);
                    setState(() {
                      Storage().restore(archive.readAsBytesSync());
                      scaffoldKey.currentState?.closeEndDrawer();
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Backup Passport'),
                trailing: const Icon(Icons.backup_rounded),
                onTap: () async {
                  if (Platform.isIOS) {
                    await ShareExtend.share(Storage().backup, "file");
                    return;
                  }
                  await Share.shareXFiles([XFile(Storage().backup)],
                      text: 'passport.zip');
                },
              ),
              const Divider(
                indent: 32,
                endIndent: 32,
              ),
              TextButton.icon(
                onPressed: () async {
                  scaffoldKey.currentState?.closeEndDrawer();
                  scaffoldKey.currentState?.showBottomSheet((context) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Are you sure that you want delete all of your data?',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.cancel_rounded),
                                  label: const Text('Cancel')),
                              Expanded(child: Container()),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    Storage().clearData();
                                    scaffoldKey.currentState?.closeEndDrawer();
                                    Navigator.of(context).pop();
                                  });
                                },
                                icon: const Icon(Icons.check_rounded),
                                label: const Text('Delete'),
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.red),
                                    foregroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text(
                  'Clear Data',
                ),
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.red)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
