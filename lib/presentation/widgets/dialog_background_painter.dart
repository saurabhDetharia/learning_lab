import 'package:flutter/material.dart';

import '../../values/app_colors.dart';

class DialogBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = AppColors.borderColor
      ..style = PaintingStyle.fill;

    final h = size.height;
    final w = size.width;

    final borderMiddleLeft = Offset(-20, h / 2 - 20);
    final borderTopMiddle = Offset(w / 2 - 20, -20);
    final borderMiddleRight = Offset(w + 20, h / 2 + 20);
    final borderBottomMiddle = Offset(w / 2 + 20, h + 20);

    final borderTopLeft = Offset(-10, -10);
    final borderTopRight = Offset(w + 20, -20);
    final borderBottomLeft = Offset(-20, h + 20);
    final borderBottomRight = Offset(w + 10, h + 10);

    Path borderPath = Path();
    borderPath.moveTo(borderMiddleLeft.dx, borderMiddleLeft.dy);
    moveConicTo(borderPath, borderTopMiddle, borderTopLeft);
    moveConicTo(borderPath, borderMiddleRight, borderTopRight);
    moveConicTo(borderPath, borderBottomMiddle, borderBottomRight);
    moveConicTo(borderPath, borderMiddleLeft, borderBottomLeft);
    borderPath.close();

    canvas.drawPath(borderPath, borderPaint);

    final middleLeft = Offset(0, h / 2);
    final topMiddle = Offset(w / 2, 0);
    final middleRight = Offset(w, h / 2);
    final bottomMiddle = Offset(w / 2, h);

    final topLeft = Offset(0, 0);
    final topRight = Offset(w, 0);
    final bottomRight = Offset(w, h);
    final bottomLeft = Offset(0, h);

    Path path = Path();
    path.moveTo(middleLeft.dx, middleLeft.dy);
    moveConicTo(path, topMiddle, topLeft);
    moveConicTo(path, middleRight, topRight);
    moveConicTo(path, bottomMiddle, bottomRight);
    moveConicTo(path, middleLeft, bottomLeft);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void moveConicTo(Path path, Offset destination, Offset controlPoint) {
    path.conicTo(
      controlPoint.dx,
      controlPoint.dy,
      destination.dx,
      destination.dy,
      2,
    );
  }
}
