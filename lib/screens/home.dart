import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Dialogs/settings.dart';
import '../repository/regex_text_controller.dart';
import '../repository/utiltes.dart';

class Home extends StatefulWidget {
  const Home() : super(key: const Key('Home'));

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final RegexTextController patternTextContoller;
  late final RegexTextController bodyTextContoller;
  final regexMatchInfo = ValueNotifier(RegexMatchInfo.init());

  String bodyText = '';
  RegExp regPattern = RegExp(r'');

  void setRegex(final String reg) {
    try {
      setState(() => regPattern = regPattern.copyWith(pattern: reg));

      handleRegexInfo(true);
    } catch (e) {
      regexMatchInfo.value = const RegexMatchInfo(
        matcheCount: 0,
        matchTime: '',
        hasError: true,
      );
    }
  }

  void handleRegexInfo(final bool canDisableError) {
    if (regexMatchInfo.value.hasError && !canDisableError) return;

    if (bodyText.isEmpty || regPattern.pattern.isEmpty) {
      regexMatchInfo.value = RegexMatchInfo.init();
      return;
    }

    final stopwatch = Stopwatch()..start();

    final matcheCount = regPattern.allMatches(bodyText).length;

    if (matcheCount == regexMatchInfo.value.matcheCount) {
      if (regexMatchInfo.value.hasError) {
        regexMatchInfo.value = regexMatchInfo.value.copyWithNoError();
      }

      stopwatch.stop();
      return;
    }

    regexMatchInfo.value = RegexMatchInfo(
      matcheCount: matcheCount,
      matchTime: '${stopwatch.elapsed.inMicroseconds / 1000} ms',
      hasError: false,
    );

    stopwatch.stop();
  }

  @override
  void initState() {
    patternTextContoller = RegexTextController(
      regPattern: regPattern,
      paintColor: Colors.green.withOpacity(0.5),
    );

    bodyTextContoller = RegexTextController(
      regPattern: RegExp(r'[^A-Za-z0-9|\s]'),
      paintColor: Colors.yellow.withOpacity(0.5),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    patternTextContoller.dispose();
    bodyTextContoller.dispose();
    regexMatchInfo.dispose();
  }

  @override
  Widget build(final context) {
    final textTheme = Theme.of(context).textTheme,
        size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 25,
          top: 15,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'DART REGULAR EXPRESSION',
                    style: textTheme.headline5,
                  ),
                ),
                ValueListenableBuilder<RegexMatchInfo>(
                  valueListenable: regexMatchInfo,
                  builder: (final context, final value, final child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: value.hasError
                            ? Colors.red
                            : value.matcheCount > 0
                                ? Colors.green
                                : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            if (value.matcheCount > 0) ...[
                              TextSpan(
                                text: '${value.matcheCount} matches ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '(${value.matchTime})',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ] else
                              TextSpan(
                                text: value.hasError
                                    ? 'pattern error'
                                    : 'not match',
                                style: const TextStyle(color: Colors.white),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: bodyTextContoller,
              onChanged: (final value) => setRegex(value),
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Regular expression',
              ),
            ),
            Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (final context) => SettingsDialog(
                        regx: regPattern,
                        onSwitch: (final regx) {
                          setState(() => regPattern = regx);
                          handleRegexInfo(false);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: regPattern.pattern),
                    );

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'Copied',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: patternTextContoller..regPattern = regPattern,
                minLines: 200,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Test string',
                ),
                onChanged: (final value) {
                  bodyText = value;
                  handleRegexInfo(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
