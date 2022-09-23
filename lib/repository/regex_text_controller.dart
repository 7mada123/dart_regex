import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegexTextController extends TextEditingController {
  RegExp regPattern;
  late final TextStyle textStyle;
  final Color paintColor;

  RegexTextController({
    final String? text,
    required this.regPattern,
    required this.paintColor,
  }) : super(text: text) {
    textStyle = TextStyle(
      background: Paint()
        ..style = PaintingStyle.fill
        ..color = paintColor,
    );
  }

  RegexTextController.fromValue(
    final TextEditingValue value, {
    required this.regPattern,
    required this.textStyle,
    required this.paintColor,
  }) : super.fromValue(value);

  @override
  TextSpan buildTextSpan({
    required final BuildContext context,
    final TextStyle? style,
    required final bool withComposing,
  }) {
    final List<TextSpan> children = [];

    text.splitMapJoin(
      regPattern,
      onMatch: (final m) {
        children.add(
          TextSpan(
            text: m[0],
            style: textStyle,
          ),
        );

        return '';
      },
      onNonMatch: (final span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
    );

    return TextSpan(style: style, children: children);
  }
}
