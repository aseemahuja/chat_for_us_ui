import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:velocity_x/velocity_x.dart';
//import 'package:http/http.dart' as http;
import 'chat_message.dart';
import 'three_dots.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class ChatScreen extends StatefulWidget {
  final String title;
  final String? imageUrl;
  const ChatScreen({super.key, required this.title, this.imageUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    setState(() {
      _isTyping = false;
    });
    super.initState();
  }

  void _sendMessage() {
    final String text = _controller.text;
    if (text.isNotEmpty) {
      _controller.clear();
      final ChatMessage message = ChatMessage(
          text: text.trim().text.bodyText1(context).make().px8(), sender: "Me");
      setState(() {
        _messages.insert(0, message);
        _isTyping = true;
      });
      fetchAnswer(text);
    }
  }

  void fetchAnswer(String question) async {
    var dio = Dio();
    final requestBody = jsonEncode({'question': question});
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      "Accept": "application/json",
      "Connection": "keep-alive",
      "Access-Control-Allow-Origin": "*"
    };

    var response = await dio.post(
        "https://chat4usnew.uc.r.appspot.com/v1/api/ask",
        data: requestBody,
        options: Options(headers: header));
    final ChatMessage message;

    if (response.statusCode == 200) {
      //final json = jsonDecode(response.data);
      message = ChatMessage(
          text: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkdownBody(data: response.data["answer"]),
          ),
          sender: "ChatBot");
    } else {
      message = ChatMessage(
          text: "Error Happened".trim().text.bodyText1(context).make().px8(),
          sender: "ChatBot");
    }

    setState(() {
      _isTyping = false;
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _controller,
          onSubmitted: (value) => _sendMessage(),
          decoration:
              const InputDecoration.collapsed(hintText: "Send a message!!"),
        )),
        IconButton(
            onPressed: () => _sendMessage(), icon: const Icon(Icons.send))
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 16, color: Colors.cyan.shade600),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            "ChatBot",
            style: TextStyle(fontSize: 18, color: Colors.cyan.shade600),
          ),
        ],
      )),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                  controller: controller,
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  }),
            )),
            if (_isTyping) const ThreeDots(),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(color: context.cardColor),
              child: _buildTextComposer(),
            ),
            Text(
              'Powered by Dream SWAP',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                  color: Color(0xFF162A49)),
            ),
          ],
        ),
      ),
    );
  }
}
