import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/provider/bottom_navigation_bar_provider.dart';

class EmptyImageWidget extends StatelessWidget {
  const EmptyImageWidget({
    required this.assetImage,
    required this.title,
    required this.subtitle,
    this.imageSize = 160,
    Key? key,
  }) : super(key: key);
  final String assetImage;
  final double imageSize;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: imageSize,
            width: imageSize,
            child: Image.asset(assetImage),
          ),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('SHOP NOW'),
            ),
          ),
        ],
      ),
    );
  }
}
