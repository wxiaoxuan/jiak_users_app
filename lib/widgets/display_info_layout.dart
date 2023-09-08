import 'package:flutter/material.dart';

import '../models/sellers.dart';

class InfoLayout extends StatefulWidget {
  const InfoLayout({super.key, this.model, required this.context});

  final Sellers? model;
  final BuildContext context;

  @override
  State<InfoLayout> createState() => _InfoLayoutState();
}

class _InfoLayoutState extends State<InfoLayout> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
