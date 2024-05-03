import 'package:flutter/material.dart';

class SitesPage extends StatefulWidget {
  const SitesPage({super.key});

  @override
  State<StatefulWidget> createState() => _SitesPageState();

}

class _SitesPageState extends State<SitesPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Text('Sites'));
  }

}