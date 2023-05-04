import 'package:chat_for_us_ui/chat_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'header.dart';
import 'input_wrapper.dart';
import 'learning_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showLoaderScreen = false;
  showLoader(String url, contextx) async {
    setState(() {
      showLoaderScreen = true;
    });
    var isValid = await checkIfUrlIsValid(url: url);

    if (!isValid) {
      setState(() {
        showLoaderScreen = false;
      });
      showErrorMessage(
        context,
        "Url provided is not Valid.",
      );
    } else {
      List responseList = await fetchTitle(url);
      String title = responseList[0];

      if (title.isEmpty || "ERROR" == title) {
        setState(() {
          showLoaderScreen = false;
        });
        showErrorMessage(
          context,
          "Error occurred while learning about the website.",
        );
      } else {
        setState(() {
          showLoaderScreen = false;
        });

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreen(
                  title: title,
                  imageUrl: responseList[1],
                )));
      }
    }
  }

  Future<List> fetchTitle(String url) async {
    var dio = Dio();
    final requestBody = jsonEncode({'url': url});
    var header = {
      'Content-type': 'application/json; charset=utf-8',
      "Accept": "application/json",
      "Connection": "keep-alive",
      "Access-Control-Allow-Origin": "*"
    };

    var response = await dio.post(
        "https://chat4usnew.uc.r.appspot.com/v1/api/scrap",
        data: requestBody,
        options: Options(headers: header));

    if (response.statusCode == 200) {
      //final json = jsonDecode(response.data);
      return [response.data["title"], response.data["iconUrl"]];
    } else {
      return ["ERROR"];
    }
  }

  showErrorMessage(BuildContext context, String contentVar) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            contentVar,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          )
        ],
      ),
      backgroundColor: Colors.red,
    ));
  }

  Future<bool> checkIfUrlIsValid({required String url}) async {
    return await canLaunchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return showLoaderScreen
        ? const LearningWidget()
        : Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.cyan[500]!,
                Colors.cyan[300]!,
                Colors.cyan[400]!
              ])),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Header(),
                  Expanded(
                      child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Column(
                      children: [
                        InputWrapper(onClick: showLoader),
                        Spacer(),
                        Text(
                          'Copyright ©2023, All Rights Reserved.',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                              color: Color(0xFF162A49)),
                        ),
                        Text(
                          'Powered by Dream SWAP',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                              color: Color(0xFF162A49)),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
          );
  }
}
