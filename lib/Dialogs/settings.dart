import 'package:flutter/material.dart';

import '../repository/utiltes.dart';

class SettingsDialog extends StatefulWidget {
  final RegExp regx;
  final void Function(RegExp newRegx) onSwitch;

  const SettingsDialog({
    required final this.regx,
    required final this.onSwitch,
  });

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final List<bool> values;
  late RegExp regExp;

  @override
  void initState() {
    regExp = widget.regx;

    values = widget.regx.getBoolValues();

    super.initState();
  }

  @override
  Widget build(final context) {
    return Dialog(
      shape: shape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (int i = 0; i < titles.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SwitchListTile(
                  shape: shape,
                  title: Text(titles[i]),
                  subtitle: Text(subtitles[i]),
                  secondary: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (final context) => ExplainDialog(
                          shape: shape,
                          explain: explains[i],
                        ),
                      );
                    },
                    icon: const Icon(Icons.info),
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: values[i],
                  onChanged: (final value) {
                    setState(() => values[i] = value);

                    switch (i) {
                      case 0:
                        regExp = regExp.copyWith(isCaseSensitive: value);
                        widget.onSwitch(regExp);
                        break;
                      case 1:
                        regExp = regExp.copyWith(isDotAll: value);
                        widget.onSwitch(regExp);
                        break;
                      case 2:
                        regExp = regExp.copyWith(isMultiLine: value);
                        widget.onSwitch(regExp);
                        break;
                      case 3:
                        regExp = regExp.copyWith(isUnicode: value);
                        widget.onSwitch(regExp);
                        break;
                    }
                  },
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

  static const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static const titles = [
    'case sensitive',
    'dot all',
    'multiLine',
    'unicode',
  ];

  static const subtitles = [
    'Whether this regular expression is case sensitive.',
    'Whether "." in this regular expression matches line terminators.',
    'Whether this regular expression matches multiple lines.',
    'Whether this regular expression is in Unicode mode.',
  ];

  static const explains = [
    '''
If the regular expression is not case sensitive, it will match an input
letter with a pattern letter even if the two letters are different case
versions of the same letter.
  ''',
    '''
This feature is distinct from [isMultiLine], as they affect the behavior
of different pattern characters, and so they can be used together or
separately.
  ''',
    '''
If the regexp does match multiple lines, the "^" and "\$" characters
match the beginning and end of lines. If not, the characters match the
beginning and end of the input.
  ''',
    '''
In Unicode mode, UTF-16 surrogate pairs in the original string will be
treated as a single code point and will not match separately. Otherwise,
the target string will be treated purely as a sequence of individual code
units and surrogates will not be treated specially.

In Unicode mode, the syntax of the RegExp pattern is more restricted, but
some pattern features, like Unicode property escapes, are only available in
this mode.
  ''',
  ];
}

class ExplainDialog extends StatelessWidget {
  const ExplainDialog({
    required final this.shape,
    required final this.explain,
  });

  final RoundedRectangleBorder shape;
  final String explain;

  @override
  Widget build(final context) {
    return Dialog(
      shape: shape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              explain,
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
}
