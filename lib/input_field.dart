import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({super.key, required this.onSubmit});
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
          child: TextField(
            maxLines: 2,
            onSubmitted: (value) {
              onSubmit(value);
            },
            onChanged: (value) => onSubmit(value),
            decoration: InputDecoration(
                hintText: "Enter the website Url",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        )
      ],
    );
  }
}
