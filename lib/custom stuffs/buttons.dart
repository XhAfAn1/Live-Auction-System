import 'package:flutter/material.dart';

Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.blue,
  Color textColor = Colors.white,
  IconData? icon,
  double borderRadius = 10.0,
  double padding = 12.0,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor),
          SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}



Widget circularIconButton({
  required IconData icon,
  required VoidCallback onPressed,
  Color color = Colors.blue,
  Color iconColor = Colors.white,
  double size = 50.0,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(size / 2),
    child: Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    ),
  );
}


Widget outlinedButton({
  required String text,
  required VoidCallback onPressed,
  Color borderColor = Colors.blue,
  Color textColor = Colors.blue,
  double borderRadius = 10.0,
  double padding = 12.0,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding * 2),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
