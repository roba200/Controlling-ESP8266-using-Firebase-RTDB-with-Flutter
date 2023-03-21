import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controlling_esp8266_with_firebase_and_flutter/frosted_glass_button.dart';
import 'package:controlling_esp8266_with_firebase_and_flutter/frosted_glass_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'firebase_options.dart';
import 'frosted_glass_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  String text = "";
  bool button = false;
  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.ref().child('value').onValue.listen((event) {
      setState(() {
        text = event.snapshot.value.toString();
        _controller.text = text;
      });
    });
    FirebaseDatabase.instance.ref().child('LED').onValue.listen((event) {
      setState(() {
        button = event.snapshot.value as bool;
      });
    });
  }

  @override
  void dispose() {
    FirebaseDatabase.instance.ref().child('value').onValue.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              "https://w0.peakpx.com/wallpaper/82/215/HD-wallpaper-cartoon-dark-black-simple.jpg"),
        ),
      ),
      child: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FrostedGlassCard(
                  child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.display,
                            size: 50,
                            color: Colors.white70,
                          ),
                          TextField(
                              controller: _controller,
                              keyboardType: TextInputType.multiline,
                              maxLength: 24,
                              cursorColor: Colors.white70,
                              style: TextStyle(color: Colors.white70)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, right: 10),
                                child: FrostedGlassButton(
                                    text: "Refrseh",
                                    height: 50,
                                    width: 150,
                                    onPressed: () {
                                      setState(() {
                                        _controller.text = text;
                                      });
                                    }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, right: 10),
                                child: FrostedGlassButton(
                                    text: "Send Text",
                                    height: 50,
                                    width: 150,
                                    onPressed: () {
                                      FirebaseDatabase.instance
                                          .ref()
                                          .child('value')
                                          .set(_controller.text);
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FrostedGlassCard(
                  child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            button
                                ? Icons.light_mode
                                : Icons.light_mode_outlined,
                            size: 60,
                            color: Colors.white70,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Transform.scale(
                              scale: 2,
                              child: Switch(
                                value: button,
                                onChanged: (value) {
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child('LED')
                                      .set(value);
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                                activeTrackColor: Colors.lightGreenAccent,
                                inactiveTrackColor: Colors.red[400],
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                splashRadius: 20,
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
          ],
        )),
      ),
    ));
  }
}
