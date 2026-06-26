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

/// Menggambar buku terbuka (dua halaman yang terbuka ke atas, dengan
/// spine/lipatan di tengah) dan petir kuning di tengahnya.
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

    // ---- BUKU TERBUKA ----
    // Halaman kiri: tepi luar lurus ke bawah, bagian atas sedikit melengkung
    // (lembaran kertas), bertemu di tengah pada spine.
    final leftPage = Path()
      ..moveTo(cx, h * 0.22) // titik atas dekat spine
      ..quadraticBezierTo(
        w * 0.24, h * 0.10, // kontrol: kertas menggembung
        w * 0.08, h * 0.20, // tepi kiri atas
      )
      ..lineTo(w * 0.08, h * 0.80) // turun ke tepi kiri bawah
      ..quadraticBezierTo(
        w * 0.24, h * 0.74,
        cx, h * 0.86, // kembali ke tengah bawah (spine bawah)
      );

    // Halaman kanan: mirror dari kiri.
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

    // Spine (lipatan tengah) menghubungkan atas & bawah buku.
    final spine = Path()
      ..moveTo(cx, h * 0.22)
      ..lineTo(cx, h * 0.86);

    canvas.drawPath(leftPage, strokePaint);
    canvas.drawPath(rightPage, strokePaint);
    canvas.drawPath(spine, strokePaint);

    // ---- PETIR ----
    // Petir kuning tebal, zig-zag klasik, melayang di atas buku.
    final boltPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    final bolt = Path()
      ..moveTo(cx + w * 0.09, h * 0.06) // ujung atas (kanan)
      ..lineTo(cx - w * 0.11, h * 0.42) // turun ke kiri
      ..lineTo(cx - w * 0.005, h * 0.42) // lekuk dalam
      ..lineTo(cx - w * 0.07, h * 0.72) // ujung bawah runcing (kiri)
      ..lineTo(cx + w * 0.13, h * 0.34) // naik ke kanan
      ..lineTo(cx + w * 0.02, h * 0.34) // lekuk dalam kembali
      ..close();

    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(covariant _BookBoltPainter oldDelegate) =>
      oldDelegate.color != color;
}
