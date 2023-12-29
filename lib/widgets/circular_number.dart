import 'package:flutter/material.dart';

class CircleNumberWidget extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final bool isTotal;
  final String text;

  const CircleNumberWidget({
    super.key,
    required this.number,
    required this.text,
    this.size = 50,
    this.color = Colors.white,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isTotal ? Colors.black45 : color,
            border: Border.all(
              color: Colors.grey, // Customize grey shade as needed
              width: 2.0, // Adjust border width as desired
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: isTotal ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(text)
      ],
    );
  }
}