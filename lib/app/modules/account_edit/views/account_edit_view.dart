import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_edit_controller.dart';

class AccountEditView extends GetView<AccountEditController> {
  const AccountEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/account'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Field untuk Nama Lengkap
              Obx(() => TextFormField(
                initialValue: controller.fullName.value,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                ),
                onChanged: (val) => controller.fullName.value = val,
                validator: (val) =>
                val == null || val.isEmpty ? 'Masukkan nama lengkap' : null,
              )),
              const SizedBox(height: 16),
              // Field untuk Username
              Obx(() => TextFormField(
                initialValue: controller.username.value,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                onChanged: (val) => controller.username.value = val,
                validator: (val) =>
                val == null || val.isEmpty ? 'Masukkan username' : null,
              )),
              const SizedBox(height: 16),
              // Field untuk Tanggal Lahir dengan DatePicker
              Obx(
                    () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cake),
                  title: Text(
                    controller.dateOfBirth.value != null
                        ? '${controller.dateOfBirth.value!.day}/${controller.dateOfBirth.value!.month}/${controller.dateOfBirth.value!.year}'
                        : 'Pilih tanggal lahir',
                  ),
                  onTap: () async {
                    DateTime initialDate =
                        controller.dateOfBirth.value ?? DateTime(2000, 1, 1);
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dateOfBirth.value = pickedDate;
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.updateUserProfile();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
