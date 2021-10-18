import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;

import './screens/home.dart';
import 'Dialogs/download.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  final pref = await SharedPreferences.getInstance();

  runApp(MyApp(pref));
}

class MyApp extends StatefulWidget {
  final SharedPreferences pref;
  const MyApp(this.pref);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode = widget.pref.getBool(isDarkModePrefKey) ?? false;

  @override
  Widget build(final context) {
    return MaterialApp(
      title: 'DART REGULAR EXPRESSION',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SafeArea(
        child: Scaffold(
          body: const Home(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Dart regex tester, created with Flutter'),
                const DownloadButton(),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    js.context.callMethod(
                      'open',
                      ['https://github.com/7mada123/dart_regex'],
                    );
                  },
                  child: const Text(
                    'SOURCE CODE AT GITHUB',
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => isDarkMode = !isDarkMode);
                    widget.pref.setBool(isDarkModePrefKey, isDarkMode);
                  },
                  child: Text(
                    'SWITCH TO ' + (isDarkMode ? 'LIGHT' : 'DARK') + ' MODE',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const isDarkModePrefKey = 'isDarkMode';
}
