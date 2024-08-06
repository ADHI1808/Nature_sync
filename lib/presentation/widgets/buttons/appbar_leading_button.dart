import 'package:flutter/material.dart';

class LeadingButton extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;

  const LeadingButton(
      {super.key, required this.iconColor, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            color: iconColor,
            size: 16,
          ),
        ),
      ),
    );
  }
}
