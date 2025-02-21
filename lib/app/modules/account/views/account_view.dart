import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/common/widgets/custom_bottombar.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accC = Get.find<AccountController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      body: Obx(() {
        if (accC.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = accC.user.value!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header profil dengan avatar dan info dasar
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0]
                                : '?',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.fullName.isNotEmpty
                              ? user.fullName
                              : 'Nama Lengkap',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@${user.username.isNotEmpty ? user.username : 'username'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          onPressed: () =>
                              Get.offAllNamed('/account-edit')
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Detail informasi akun
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.cake),
                    title: const Text('Tanggal Lahir'),
                    subtitle: Text(user.dateOfBirth != null
                        ? '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'
                        : 'Belum diatur'),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol logout
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () => accC.logout(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
