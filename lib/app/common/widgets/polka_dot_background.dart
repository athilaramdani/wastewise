import 'package:flutter/material.dart';
import '../../common/theme/app_theme.dart';

class PolkaDotBackground extends StatefulWidget {
  const PolkaDotBackground({Key? key}) : super(key: key);

  @override
  State<PolkaDotBackground> createState() => _PolkaDotBackgroundState();
}

class _PolkaDotBackgroundState extends State<PolkaDotBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Durasi animasi misalnya 5 detik bolak-balik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Tween offset polka dot
    _animation = Tween<double>(begin: 0.0, end: 15.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _PolkaDotPainter(_animation.value),
          child: Container(), // Wajib ada child Container agar area terisi
        );
      },
    );
  }
}

class _PolkaDotPainter extends CustomPainter {
  final double offset;

  _PolkaDotPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.greenDark.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    const double radius = 6.0;
    const double spacing = 50.0;

    // Buat pola polka dot dengan jarak spacing
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Offset horizontal & vertical diubah sedikit oleh animasi
        final dx = x + offset;
        final dy = y + offset;
        canvas.drawCircle(Offset(dx, dy), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PolkaDotPainter oldDelegate) {
    // Gambar ulang jika nilai offset berbeda
    return oldDelegate.offset != offset;
  }
}