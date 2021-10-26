import 'package:flutter/material.dart';
import 'package:volt_arena/utilities/utilities.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({required this.onTap, required this.text, Key? key})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Utilities.padding / 2),
        padding: EdgeInsets.symmetric(
          vertical: Utilities.padding / 2,
          horizontal: Utilities.padding * 3,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Utilities.borderRadius),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
