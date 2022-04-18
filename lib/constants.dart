import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);

final divider = Divider(color: white.withOpacity(0.3), height: 1);

class _TodayInCustomerData {
  _TodayInCustomerData(this.time, this.count);
  final String time;
  final double count;
}




ListView l = ListView.builder(
  padding: const EdgeInsets.only(top: 10),
  itemBuilder: (context, index) => Container(
    height: 100,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10, right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).canvasColor,
      boxShadow: const [BoxShadow()],
    ),
  ),
);