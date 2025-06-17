import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/jadwal_baberman_controller.dart';

class JadwalBabermanView extends GetView<JadwalBabermanController> {
  const JadwalBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jadwal Baberman'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                decoration: const InputDecoration(
                  labelText: "Pilih Baberman",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

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
                decoration: const InputDecoration(
                  labelText: "Pilih Layanan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔽 Tanggal
              TextFormField(
                readOnly: true,
                controller: controller.dateC,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: controller.pickDate,
              ),
              const SizedBox(height: 16),

              // 🔽 Jam
              TextFormField(
                readOnly: true,
                controller: controller.timeC,
                decoration: const InputDecoration(
                  labelText: 'Jam',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: controller.pickTime,
              ),
              const SizedBox(height: 24),

              // 🔽 Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Jadwal'),
                  onPressed: controller.saveJadwal,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
