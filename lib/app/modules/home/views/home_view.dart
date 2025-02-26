import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:wastewise/app/common/widgets/custom_bottombar.dart';
import 'package:wastewise/app/common/widgets/greeting_header.dart';
import 'package:wastewise/app/common/widgets/waste_analytics_card.dart';

import '../controllers/home_controller.dart';
import '../../../data/models/waste_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('WasteWise'),
        centerTitle: true,
        elevation: 0,
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Greeting + Switch Dark/Light
            Obx(() {
              String userName = homeC.userName.value;  // ambil dari controller
              bool isDark = homeC.isDarkMode.value;

              return GreetingHeader(
                userName: userName.isEmpty ? "User" : userName,
                isDarkMode: isDark,
                onThemeChanged: (val) => homeC.toggleTheme(val),
              );
            }),

            const SizedBox(height: 24),

            // 2) Card Analytics
            Obx(() {
              // Hitung total waste hari ini
              double todayWaste = _calculateTodayWaste(homeC.wasteList);
              // Hitung total waste 7 hari terakhir
              double weeklyWaste = _calculateWeeklyWaste(homeC.wasteList);

              // Bikin data harian 7 hari terakhir [day1, day2, ..., day7]
              List<double> dailyWasteList =
              _calculateDailyWasteFor7Days(homeC.wasteList);

              return WasteAnalyticsCard(
                totalWaste: "${todayWaste.toStringAsFixed(1)} Kg",
                weeklyWaste: "${weeklyWaste.toStringAsFixed(1)} Kg",
                weeklyData: dailyWasteList,
                onTap: () {
                  // Aksi jika card ditekan, misal buka halaman detail
                },
              );
            }),

            const SizedBox(height: 24),

            // 3) Form Input Data Sampah
            _buildWasteForm(context, homeC),

            const SizedBox(height: 24),

            // 4) Daftar Data Sampah
            Text(
              "Daftar Sampah",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            Obx(() {
              if (homeC.wasteList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Belum ada data sampah yang dicatat.'),
                );
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: homeC.wasteList.length,
                itemBuilder: (context, index) {
                  final waste = homeC.wasteList[index];
                  return _buildWasteItem(context, waste);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Widget form perekaman sampah
  Widget _buildWasteForm(BuildContext context, HomeController homeC) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Catat Sampahmu",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => homeC.wasteType.value = val,
              decoration: const InputDecoration(
                labelText: 'Jenis Sampah',
                hintText: 'Contoh: organik, plastik, dll.',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) =>
              homeC.wasteAmount.value = double.tryParse(val) ?? 0.0,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat/Volume (Kg/L)',
                hintText: 'Contoh: 2.5 (Kg)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => homeC.addWaste(),
              child: const Text('Tambah Data Sampah'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget item data waste
  Widget _buildWasteItem(BuildContext context, WasteModel waste) {
    final homeC = Get.find<HomeController>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text('${waste.type} - ${waste.amount} Kg'),
        subtitle: Text(
          'Dibuat pada: ${DateFormat('dd/MM/yyyy HH:mm').format(waste.date)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context, waste);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                homeC.deleteWaste(waste.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog edit
  void _showEditDialog(BuildContext context, WasteModel waste) {
    final homeC = Get.find<HomeController>();
    final typeController = TextEditingController(text: waste.type);
    final amountController =
    TextEditingController(text: waste.amount.toString());

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Data Sampah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration:
                const InputDecoration(labelText: 'Jenis Sampah'),
              ),
              TextField(
                controller: amountController,
                decoration:
                const InputDecoration(labelText: 'Berat/Volume'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newType = typeController.text.trim();
                final newAmount =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                homeC.updateWaste(waste, newType, newAmount);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  /// Hitung total sampah HARI INI
  double _calculateTodayWaste(List<WasteModel> list) {
    DateTime now = DateTime.now();
    return list.where((w) {
      return w.date.year == now.year &&
          w.date.month == now.month &&
          w.date.day == now.day;
    }).fold(0.0, (sum, w) => sum + w.amount);
  }

  /// Hitung total sampah MINGGU INI (7 hari ke belakang)
  double _calculateWeeklyWaste(List<WasteModel> list) {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    return list.where((w) {
      return w.date.isAfter(sevenDaysAgo) &&
          w.date.isBefore(now.add(const Duration(days: 1)));
    }).fold(0.0, (sum, w) => sum + w.amount);
  }

  /// Hitung sampah harian 7 hari terakhir: [day1, day2, ..., day7]
  /// Urutan day1 = 7 hari lalu, day7 = hari ini
  List<double> _calculateDailyWasteFor7Days(List<WasteModel> list) {
    List<double> dailyData = List.filled(7, 0.0);

    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      // Hari ke-i dihitung mundur
      DateTime day = now.subtract(Duration(days: 6 - i));
      // day di sini mulai dari 6 hari lalu hingga 0 hari lalu (hari ini)
      double sumWaste = list.where((w) {
        return w.date.year == day.year &&
            w.date.month == day.month &&
            w.date.day == day.day;
      }).fold(0.0, (sum, w) => sum + w.amount);

      dailyData[i] = sumWaste;
    }
    return dailyData;
  }
}
