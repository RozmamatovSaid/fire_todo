import 'package:flutter/material.dart';

extension GapExtension on num {
  Widget get g => Gap(toDouble());
}

class Gap extends StatelessWidget {
  final double size;

  const Gap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    final Flex? parentFlex = context.findAncestorWidgetOfExactType<Flex>();

    if (parentFlex != null) {
      if (parentFlex.direction == Axis.horizontal) {
        return SizedBox(width: size);
      } else {
        return SizedBox(height: size);
      }
    } else {
      return SizedBox(height: size);
    }
  }
}
