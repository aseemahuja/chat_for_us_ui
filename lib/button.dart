import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onClick;
  const Button({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            color: Colors.cyan[500], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "Train the Chatbot",
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
