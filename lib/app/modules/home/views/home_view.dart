import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wastewise/app/common/widgets/custom_bottombar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WasteWise Home'),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 24.0),
          child: Column(
            children: [
              // Banner / Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Selamat Datang di WasteWise!\nMari kelola sampah dengan bijak.",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),

              // Form input
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(height: 8),
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
              ),
              const SizedBox(height: 16),

              // List data
              Obx(() {
                if (homeC.wasteList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Belum ada data sampah yang dicatat'),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: homeC.wasteList.length,
                  itemBuilder: (context, index) {
                    final waste = homeC.wasteList[index];
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
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, waste) {
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
}
