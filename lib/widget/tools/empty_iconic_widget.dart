import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/provider/bottom_navigation_bar_provider.dart';

class EmptyIconicWidget extends StatelessWidget {
  const EmptyIconicWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSize = 60,
    Key? key,
  }) : super(key: key);
  final IconData icon;
  final double iconSize;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 60, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Consumer<BottomNavigationBarProvider>(
            builder: (
              BuildContext context,
              BottomNavigationBarProvider page,
              _,
            ) =>
                TextButton(
              onPressed: () {
                page.updateSelectedPage(0);
                Navigator.of(context).pop();
              },
              child: const Text('SHOP NOW'),
            ),
          ),
        ],
      ),
    );
  }
}
