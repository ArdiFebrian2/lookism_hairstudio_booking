import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/jadwal_baberman_controller.dart';

class JadwalBabermanView extends GetView<JadwalBabermanController> {
  const JadwalBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jadwal Barberman'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 🔽 Dropdown barberman
                  DropdownButtonFormField<String>(
                    value:
                        controller.selectedBarbermanId.value.isEmpty
                            ? null
                            : controller.selectedBarbermanId.value,
                    items:
                        controller.barbermen.map((barber) {
                          return DropdownMenuItem<String>(
                            value: barber['id'],
                            child: Text(barber['name'] ?? ''),
                          );
                        }).toList(),
                    onChanged: (value) {
                      controller.selectedBarbermanId.value = value ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Pilih Barberman",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔽 Dropdown layanan
                  DropdownButtonFormField<String>(
                    value:
                        controller.selectedService.value.isEmpty
                            ? null
                            : controller.selectedService.value,
                    items:
                        controller.services.map((service) {
                          return DropdownMenuItem<String>(
                            value: service['name'],
                            child: Text(service['name'] ?? ''),
                          );
                        }).toList(),
                    onChanged: (value) {
                      controller.selectedService.value = value ?? '';
                    },
                    decoration: InputDecoration(
                      labelText: "Pilih Layanan",
                      prefixIcon: const Icon(Icons.cut),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔽 Tanggal
                  TextFormField(
                    readOnly: true,
                    controller: controller.dateC,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    onTap: controller.pickDate,
                  ),
                  const SizedBox(height: 20),

                  // 🔽 Jam
                  TextFormField(
                    readOnly: true,
                    controller: controller.timeC,
                    decoration: InputDecoration(
                      labelText: 'Jam',
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    onTap: controller.pickTime,
                  ),
                  const SizedBox(height: 30),

                  // 🔽 Tombol simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Jadwal'),
                      onPressed: controller.saveJadwal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
