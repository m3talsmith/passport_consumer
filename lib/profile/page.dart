import 'package:clipboard/clipboard.dart';
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Container(
                  height: 80,
                ),
                TextFormField(
                  initialValue: Storage().user.displayName,
                  decoration: decorateTextField(context, label: 'Display Name'),
                  onChanged: (value) {
                    setState(() {
                      Storage().user.displayName = value;
                      Storage().user.save();
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(
                    bottom:
                        BorderSide(color: Theme.of(context).highlightColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.key_rounded),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width / 3) * 2,
                  child: Text(
                    Storage().publicKey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var scaffoldMessenger = ScaffoldMessenger.of(context);
                      await FlutterClipboard.copy(Storage().publicKey);
                      scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Public key copied')));
                    },
                    icon: Icon(
                      Icons.copy_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

InputDecoration decorateTextField(BuildContext context, {String? label}) {
  return InputDecoration(
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none),
    label: label != null ? const Text('Display Name') : null,
    filled: true,
    fillColor: Theme.of(context).colorScheme.tertiary,
  );
}
