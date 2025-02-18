import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wastewise/app/common/widgets/custom_bottombar.dart';
import '../controllers/wisebot_controller.dart';

class WisebotView extends GetView<WisebotController> {
  const WisebotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wiseC = Get.find<WisebotController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WiseBot Chat'),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          // List pesan
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: wiseC.messages.length,
                itemBuilder: (context, index) {
                  final msg = wiseC.messages[index];
                  final isUser = (msg['role'] == 'user');
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.green.shade200
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg['content'] ?? ''),
                    ),
                  );
                },
              );
            }),
          ),
          // Input field
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return TextField(
                      onChanged: (val) => wiseC.userMessage.value = val,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                      ),
                      controller: TextEditingController(
                        text: wiseC.userMessage.value,
                      )
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: wiseC.userMessage.value.length),
                        ),
                    );
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => wiseC.sendMessage(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
