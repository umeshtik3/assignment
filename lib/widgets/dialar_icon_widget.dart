import 'package:flutter/material.dart';

class DialerIcon extends StatelessWidget {
  const DialerIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.phone,
        color: Colors.blue,
      ),
      onPressed: () => _launchDialer(),
    );
  }

  void _launchDialer() async {
    // TODO (umesh): to implement dial feature
  }
}