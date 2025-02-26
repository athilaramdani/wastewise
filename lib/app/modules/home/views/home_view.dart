import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:flutter_map/flutter_map.dart';

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
            // Greeting + Switch Dark/Light
            Obx(() {
              String userName = homeC.userName.value;
              bool isDark = homeC.isDarkMode.value;
              return GreetingHeader(
                userName: userName.isEmpty ? "User" : userName,
                isDarkMode: isDark,
                onThemeChanged: (val) => homeC.toggleTheme(val),
              );
            }),
            const SizedBox(height: 24),

            // Card Analytics
            Obx(() {
              double todayWaste = _calculateTodayWaste(homeC.wasteList);
              double weeklyWaste = _calculateWeeklyWaste(homeC.wasteList);
              List<double> dailyWasteList = _calculateDailyWasteFor7Days(homeC.wasteList);
              return WasteAnalyticsCard(
                totalWaste: "${todayWaste.toStringAsFixed(1)} Kg",
                weeklyWaste: "${weeklyWaste.toStringAsFixed(1)} Kg",
                weeklyData: dailyWasteList,
                onTap: () {
                },
              );
            }),
            const SizedBox(height: 24),

            // Form Input Data Sampah
            _buildWasteForm(context, homeC),
            const SizedBox(height: 24),

            // Daftar Data Sampah (menampilkan 5 data terlebih dahulu)
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
              final list = homeC.wasteList;
              final showAll = homeC.showAllWaste.value;
              final itemCount = showAll ? list.length : (list.length > 5 ? 5 : list.length);
              return Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final waste = list[index];
                      return _buildWasteItem(context, waste);
                    },
                  ),
                  if (!showAll && list.length > 5)
                    TextButton(
                      onPressed: () {
                        homeC.showAllWaste.value = true;
                      },
                      child: const Text("Tampilkan Semua"),
                    ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // 5) Peta OSM: tampilkan marker lokasi user (biru), waste orang lain (hijau)
            //    dan waste milik user (merah)
            Text(
              "Lokasi Pembuangan Sampah",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              double lat = homeC.currentLat.value;
              double lng = homeC.currentLng.value;
              if (lat == 0.0 && lng == 0.0) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: lat_lng.LatLng(lat, lng),
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        // Marker lokasi user (biru)
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: lat_lng.LatLng(lat, lng),
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                        // Marker untuk waste orang lain (hijau)
                        ...homeC.otherWasteList.map((w) {
                          if (w.latitude != null && w.longitude != null) {
                            return Marker(
                              width: 80.0,
                              height: 80.0,
                              point: lat_lng.LatLng(w.latitude!, w.longitude!),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Detail Sampah"),
                                      content: Text(
                                          "Jenis: ${w.type}\nBerat/Volume: ${w.amount} Kg/L"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Tutup"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                            );
                          } else {
                            return Marker(
                              width: 0,
                              height: 0,
                              point: lat_lng.LatLng(0, 0),
                              child: const SizedBox(),
                            );
                          }
                        }).toList(),
                        // Marker untuk waste milik user (merah)
                        ...homeC.wasteList.map((w) {
                          if (w.latitude != null && w.longitude != null) {
                            return Marker(
                              width: 80.0,
                              height: 80.0,
                              point: lat_lng.LatLng(w.latitude!, w.longitude!),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Detail Sampah (Anda)"),
                                      content: Text(
                                          "Jenis: ${w.type}\nBerat/Volume: ${w.amount} Kg/L"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("Tutup"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            );
                          } else {
                            return Marker(
                              width: 0,
                              height: 0,
                              point: lat_lng.LatLng(0, 0),
                              child: const SizedBox(),
                            );
                          }
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

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
              controller: homeC.wasteTypeController,
              onChanged: (val) => homeC.wasteType.value = val,
              decoration: const InputDecoration(
                labelText: 'Jenis Sampah',
                hintText: 'Contoh: organik, plastik, dll.',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: homeC.wasteAmountController,
              keyboardType: TextInputType.number,
              onChanged: (val) => homeC.wasteAmount.value =
                  double.tryParse(val) ?? 0.0,
              decoration: const InputDecoration(
                labelText: 'Berat/Volume (Kg/L)',
                hintText: 'Contoh: 2.5 (Kg)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await homeC.addWaste();
              },
              child: const Text('Tambah Data Sampah'),
            ),
          ],
        ),
      ),
    );
  }

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

  void _showEditDialog(BuildContext context, WasteModel waste) {
    final homeC = Get.find<HomeController>();
    final typeController = TextEditingController(text: waste.type);
    final amountController = TextEditingController(text: waste.amount.toString());
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
                decoration: const InputDecoration(labelText: 'Jenis Sampah'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Berat/Volume'),
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
                final newAmount = double.tryParse(amountController.text.trim()) ?? 0.0;
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

  double _calculateTodayWaste(List<WasteModel> list) {
    final now = DateTime.now();
    return list
        .where((w) =>
    w.date.year == now.year &&
        w.date.month == now.month &&
        w.date.day == now.day)
        .fold(0.0, (sum, w) => sum + w.amount);
  }

  double _calculateWeeklyWaste(List<WasteModel> list) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return list
        .where((w) =>
    w.date.isAfter(sevenDaysAgo) &&
        w.date.isBefore(now.add(const Duration(days: 1))))
        .fold(0.0, (sum, w) => sum + w.amount);
  }

  List<double> _calculateDailyWasteFor7Days(List<WasteModel> list) {
    List<double> dailyData = List.filled(7, 0.0);
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      final sumWaste = list
          .where((w) =>
      w.date.year == day.year &&
          w.date.month == day.month &&
          w.date.day == day.day)
          .fold(0.0, (sum, w) => sum + w.amount);
      dailyData[i] = sumWaste;
    }
    return dailyData;
  }
}
