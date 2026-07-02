import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdaTamuLogo extends StatelessWidget {
  final double scale;
  final bool showText;

  const AdaTamuLogo({
    super.key,
    this.scale = 1.0,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 110 * scale,
          height: 80 * scale,
          child: CustomPaint(
            painter: _BookBoltPainter(color: AppColors.logoIcon),
          ),
        ),
        if (showText) SizedBox(height: 8 * scale),
        if (showText)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ada',
                  style: AppTextStyles.logoAdaText.copyWith(
                    fontSize: 28 * scale,
                  ),
                ),
                TextSpan(
                  text: 'Tamu',
                  style: AppTextStyles.logoTamuText.copyWith(
                    fontSize: 28 * scale,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BookBoltPainter extends CustomPainter {
  final Color color;

  _BookBoltPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final leftPage = Path()
      ..moveTo(cx, h * 0.22)
      ..quadraticBezierTo(
        w * 0.24,
        h * 0.10,
        w * 0.08,
        h * 0.20,
      )
      ..lineTo(w * 0.08, h * 0.80)
      ..quadraticBezierTo(
        w * 0.24,
        h * 0.74,
        cx,
        h * 0.86,
      );

    final rightPage = Path()
      ..moveTo(cx, h * 0.22)
      ..quadraticBezierTo(
        w * 0.76,
        h * 0.10,
        w * 0.92,
        h * 0.20,
      )
      ..lineTo(w * 0.92, h * 0.80)
      ..quadraticBezierTo(
        w * 0.76,
        h * 0.74,
        cx,
        h * 0.86,
      );

    final spine = Path()
      ..moveTo(cx, h * 0.22)
      ..lineTo(cx, h * 0.86);

    canvas.drawPath(leftPage, strokePaint);
    canvas.drawPath(rightPage, strokePaint);
    canvas.drawPath(spine, strokePaint);

    final boltPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    final bolt = Path()
      ..moveTo(cx + w * 0.09, h * 0.06)
      ..lineTo(cx - w * 0.11, h * 0.42)
      ..lineTo(cx - w * 0.005, h * 0.42)
      ..lineTo(cx - w * 0.07, h * 0.72)
      ..lineTo(cx + w * 0.13, h * 0.34)
      ..lineTo(cx + w * 0.02, h * 0.34)
      ..close();

    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(covariant _BookBoltPainter oldDelegate) =>
      oldDelegate.color != color;
}
