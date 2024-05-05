import 'package:flutter/material.dart';
import 'package:passport/storage/storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            children: [
              Container(height: 80,),
            ],
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(bottom: BorderSide(color: Theme.of(context).highlightColor))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Storage().publicKey),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.copy_rounded))
              ],
            ),
          )
        ],
      ),
    );
  }
}
