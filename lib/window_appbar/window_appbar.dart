import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WindowAppBar({
    super.key,
  });

  @override
  final Size preferredSize = const Size(double.infinity, 40);

  @override
  Widget build(BuildContext context) => const _WindowAppBar();
}

class _WindowAppBar extends StatelessWidget {
  const _WindowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: MediaQuery.of(context).size,
      child: MoveWindow(),
    );
  }
}


// class WindowButtons extends StatelessWidget {
//   const WindowButtons({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         MinimizeWindowButton(colors: buttonColors),
//         MaximizeWindowButton(colors: buttonColors),
//         CloseWindowButton(colors: closeButtonColors),
//       ],
//     );
//   }
// }
