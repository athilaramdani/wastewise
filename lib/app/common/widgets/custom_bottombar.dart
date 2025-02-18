import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/common/theme/app_theme.dart';

// Custom Bottom Navigation Bar
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.primaryGreen,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // HOME
            IconButton(
              onPressed: () => Get.offAllNamed('/home'),
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.white : Colors.white54,
                // jika di page Home => fill putih, jika tidak => outline/white54
              ),
            ),
            // WISEBOT
            IconButton(
              onPressed: () => Get.offAllNamed('/wisebot'),
              icon: Icon(
                Icons.chat,
                color: currentIndex == 1 ? Colors.white : Colors.white54,
              ),
            ),
            // ACCOUNT
            IconButton(
              onPressed: () => Get.offAllNamed('/account'),
              icon: Icon(
                Icons.person,
                color: currentIndex == 2 ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
