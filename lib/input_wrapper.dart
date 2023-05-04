import 'package:flutter/material.dart';

import 'button.dart';
import 'input_field.dart';

class InputWrapper extends StatelessWidget {
  final Function(String, BuildContext) onClick;
  const InputWrapper({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    String url = "";
    void updateUrl(String urlVal) {
      url = urlVal;
    }

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InputField(
              onSubmit: updateUrl,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Button(onClick: () => onClick(url, context))
        ],
      ),
    );
  }
}
