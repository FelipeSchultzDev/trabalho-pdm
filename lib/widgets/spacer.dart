import 'package:flutter/material.dart';
import 'package:projeto_final/screens/splash_screen.dart';

class ItemSpacer extends StatelessWidget {
  const ItemSpacer({super.key, this.space});

  final double? space;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: mq.height * (space ?? 0.03));
  }
}
