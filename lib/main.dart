import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main(){
  runApp(const UrlShortnerApp());
}

class UrlShortnerApp extends StatefulWidget {
  const UrlShortnerApp({super.key});

  @override
  State<UrlShortnerApp> createState() => _UrlShortnerAppState();
}

class _UrlShortnerAppState extends State<UrlShortnerApp> {

  TextEditingController controller = TextEditingController();
  var shortenLink = '';

  Future<String> getData() async {
     var url = controller.text;
    var response = await http.get(Uri.parse('https://api.shrtco.de/v2/shorten?url=$url'));
    var jasonData = jsonDecode(response.body);

    setState(() {
      shortenLink = jasonData ['result'] ['short_link'];
    });

    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Shortner',
      theme: ThemeData(
        primarySwatch: Colors.teal
      ),
      
      home: Scaffold(
        appBar: AppBar(title: const Text('URL Shortner'), centerTitle: true,),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  label: const Text('URL'),
                  hintText: 'Enter URL',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.teal
                    ),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder:  OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.teal
                    ),

                    borderRadius: BorderRadius.circular(10),
                  )
                ),

              ),
              const SizedBox(height: 20,),

              Text('Shortner Link:  $shortenLink',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),

              ),

              const SizedBox(height: 20,),

              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){

                    getData();

                  },
                      child: const Text('Click to Short')),

                  ElevatedButton(onPressed: (){
                    FlutterClipboard.copy('$shortenLink');
                  },
                      child: const Text('Copy to Clipboard')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
