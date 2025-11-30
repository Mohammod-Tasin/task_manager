import 'package:flutter/material.dart';

class AddWaterBtn extends StatelessWidget {
  final int amount;
  final String plusOrMinus;
  IconData ? icon;
  final VoidCallback onclick;
  AddWaterBtn({
    super.key, required this.amount, required this.onclick, this.icon, required this.plusOrMinus
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 8, 90, 8),
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          onPressed: onclick,
          icon: Icon(icon ?? Icons.water_drop_outlined, color: Colors.blue),
          label: Text("$plusOrMinus$amount LTR", style: TextStyle(color: Colors.blue)),
        ),
      ),
    );
  }
}