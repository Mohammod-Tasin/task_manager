import 'package:flutter/material.dart';

class CButtons extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color iconColor;
  final VoidCallback onTap;
  final BoxShape boxShape;
  const CButtons({
    super.key,
    required this.buttonText,
    this.buttonColor = Colors.white24,
    required this.iconColor,
    required this.onTap,
    this.boxShape= BoxShape.circle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: boxShape,
          color: buttonColor,
          // borderRadius: BorderRadius.circular(60)
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          buttonText.toString(),
          style: TextStyle(
            fontSize: 25,
            color: iconColor
          ),
        )
      ),
    );
  }
}
