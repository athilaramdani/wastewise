import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/theme/app_theme.dart';

class PolkaDotController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  final offset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0.0, end: 15.0).animate(animationController)
      ..addListener(() {
        offset.value = animation.value;
      });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class PolkaDotBackground extends StatelessWidget {
  const PolkaDotBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final polkaC = Get.put(PolkaDotController());

    return Obx(() {
      return CustomPaint(
        painter: _PolkaDotPainter(polkaC.offset.value),
        child: Container(), // agar area canvas terisi
      );
    });
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

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final dx = x + offset;
        final dy = y + offset;
        canvas.drawCircle(Offset(dx, dy), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PolkaDotPainter oldDelegate) {
    // Repaint jika offset berbeda
    return oldDelegate.offset != offset;
  }
}
