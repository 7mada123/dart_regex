import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import './Dialogs/download.dart';
import './screens/home.dart';
import 'window_appbar/window_appbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pref = await SharedPreferences.getInstance();

  runApp(MyApp(pref));

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  final SharedPreferences pref;
  const MyApp(this.pref) : super(key: const Key("MyApp"));

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
          appBar: const WindowAppBar(),
          body: const Home(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Dart regex tester, created with Flutter'),
                const SizedBox(width: 10),
                const DownloadButton(),
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse('https://github.com/7mada123/dart_regex'),
                  ),
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
                    "SWITCH TO ${isDarkMode ? 'LIGHT' : 'DARK'} MODE",
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
