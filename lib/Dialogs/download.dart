import 'package:flutter/material.dart';
import 'dart:js' as js;

class DownloadDialog extends StatelessWidget {
  const DownloadDialog();

  @override
  Widget build(final context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final os in osLink.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    js.context.callMethod(
                      'open',
                      [os.value],
                    );
                  },
                  child: Text(os.key),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  static const osLink = {
    'Windows':
        'https://drive.google.com/file/d/1U7AsBiKy4qce-24ma6wfceuTB8Qwkf4m/view?usp=sharing',
    // 'Linux': 'link',
    // 'Mac': 'link',
    // 'IOS': 'link',
    'Android':
        'https://play.google.com/store/apps/details?id=com.hamada.dart_regex_app',
  };
}

class DownloadButton extends StatelessWidget {
  const DownloadButton();

  @override
  Widget build(final context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (final context) => const DownloadDialog(),
        );
      },
      child: const Text('DOWNLOAD APP'),
    );
  }
}
