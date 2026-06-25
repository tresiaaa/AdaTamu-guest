import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo "AdaTamu": ikon buku terbuka dengan petir di tengah, lalu teks
/// "Ada" (biru) + "Tamu" (kuning).
///
/// PENTING: bentuk ikon (buku + petir) dan warna teks ("Ada" = biru,
/// "Tamu" = kuning) sudah final sesuai permintaan dan TIDAK BOLEH diubah.
/// Jika perlu memperbesar/memperkecil logo, gunakan parameter [scale],
/// jangan mengubah path di [_BookBoltPainter].
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

/// Menggambar siluet buku terbuka (dua sisi melengkung simetris)
/// dengan petir di tengah, sesuai logo pada gambar referensi.
class _BookBoltPainter extends CustomPainter {
  final Color color;

  _BookBoltPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final centerX = w / 2;

    // Sisi kiri buku: dari atas-tengah, melengkung ke bawah lalu kembali
    // ke tengah-bawah membentuk satu "kelopak" buku.
    final leftPage = Path()
      ..moveTo(centerX, h * 0.12)
      ..cubicTo(
        centerX - w * 0.18, h * 0.02,
        w * 0.06, h * 0.05,
        w * 0.06, h * 0.30,
      )
      ..cubicTo(
        w * 0.06, h * 0.55,
        w * 0.06, h * 0.80,
        w * 0.06, h * 0.80,
      )
      ..cubicTo(
        w * 0.06, h * 0.80,
        centerX - w * 0.20, h * 0.78,
        centerX, h * 0.92,
      );

    // Sisi kanan buku: mirror dari sisi kiri.
    final rightPage = Path()
      ..moveTo(centerX, h * 0.12)
      ..cubicTo(
        centerX + w * 0.18, h * 0.02,
        w * 0.94, h * 0.05,
        w * 0.94, h * 0.30,
      )
      ..cubicTo(
        w * 0.94, h * 0.55,
        w * 0.94, h * 0.80,
        w * 0.94, h * 0.80,
      )
      ..cubicTo(
        w * 0.94, h * 0.80,
        centerX + w * 0.20, h * 0.78,
        centerX, h * 0.92,
      );

    // Garis tengah buku (tulang punggung / spine), sedikit melengkung.
    final spine = Path()
      ..moveTo(centerX, h * 0.12)
      ..quadraticBezierTo(
        centerX - w * 0.01, h * 0.50,
        centerX, h * 0.92,
      );

    canvas.drawPath(leftPage, strokePaint);
    canvas.drawPath(rightPage, strokePaint);
    canvas.drawPath(spine, strokePaint);

    // Petir kuning di tengah buku, mengikuti bentuk kilat khas (zig-zag).
    final boltPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    final bolt = Path()
      ..moveTo(centerX + w * 0.07, h * 0.18)
      ..lineTo(centerX - w * 0.06, h * 0.46)
      ..lineTo(centerX + w * 0.005, h * 0.46)
      ..lineTo(centerX - w * 0.07, h * 0.80)
      ..lineTo(centerX + w * 0.10, h * 0.50)
      ..lineTo(centerX + w * 0.02, h * 0.50)
      ..close();

    canvas.drawPath(bolt, boltPaint);
  }

  @override
  bool shouldRepaint(covariant _BookBoltPainter oldDelegate) =>
      oldDelegate.color != color;
}
