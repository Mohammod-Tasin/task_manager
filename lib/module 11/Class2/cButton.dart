import 'package:flutter/material.dart';

class cButton extends StatelessWidget {
  String text;
  Color ? color;
  final VoidCallback onTap;
  cButton({
    super.key,
    required this.onTap,
    this.color,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              backgroundColor: color ?? Colors.grey[800],
            ),
            onPressed: onTap, child: Text(text,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
        )),
      ),
    );
  }
}
