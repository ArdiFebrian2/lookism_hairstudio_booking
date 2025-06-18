import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kelola_baberman_controller.dart';

class KelolaBabermanView extends GetView<KelolaBabermanController> {
  const KelolaBabermanView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => KelolaBabermanController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kelola Baberman',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple[700],
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withOpacity(0.1),
                  Colors.deepPurple.withOpacity(0.3),
                  Colors.deepPurple.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.deepPurple[700],
              size: 18,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return _buildEmptyState();
        }
        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh data logic here
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: Colors.deepPurple,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return _buildUserCard(context, user, index);
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurple[100]!, Colors.deepPurple[50]!],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.content_cut_rounded,
              size: 60,
              color: Colors.deepPurple[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Baberman',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan baberman pertama Anda\nuntuk memulai mengelola layanan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showForm(Get.context!, null),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Baberman'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple[600]!, Colors.deepPurple[700]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    '${controller.users.length} Baberman',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'Terdaftar dalam sistem',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    Map<String, dynamic> user,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar_${user['uid']}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.primaries[index %
                              Colors.primaries.length][400]!,
                          Colors.primaries[index %
                              Colors.primaries.length][600]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.content_cut_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user['alamat'],
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user['telepon'],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        onPressed: () => _showForm(context, user),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red[600],
                          size: 20,
                        ),
                        onPressed: () => _showDeleteConfirmation(context, user),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showForm(context, null),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> user,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.red[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Konfirmasi Hapus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${user['nama']}? Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteBaberman(user['uid']);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, Map<String, dynamic>? item) {
    final namaController = TextEditingController(text: item?['nama']);
    final alamatController = TextEditingController(text: item?['alamat']);
    final teleponController = TextEditingController(text: item?['telepon']);
    final emailController = TextEditingController(text: item?['email']);
    final passwordController = TextEditingController();

    final isEdit = item != null;

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple[400]!,
                          Colors.deepPurple[600]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isEdit ? 'Edit Baberman' : 'Tambah Baberman',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildTextField(
                controller: namaController,
                label: 'Nama Lengkap',
                icon: Icons.person_rounded,
                hint: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: alamatController,
                label: 'Alamat',
                icon: Icons.location_on_rounded,
                hint: 'Masukkan alamat lengkap',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: teleponController,
                label: 'Nomor Telepon',
                icon: Icons.phone_rounded,
                hint: 'Masukkan nomor telepon',
                keyboardType: TextInputType.phone,
              ),
              if (!isEdit) ...[
                const SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email_rounded,
                  hint: 'Masukkan alamat email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock_rounded,
                  hint: 'Masukkan password',
                  obscureText: true,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (namaController.text.isEmpty ||
                        alamatController.text.isEmpty ||
                        teleponController.text.isEmpty ||
                        (!isEdit &&
                            (emailController.text.isEmpty ||
                                passwordController.text.isEmpty))) {
                      Get.snackbar(
                        'Validasi',
                        'Semua field wajib diisi',
                        backgroundColor: Colors.red[50],
                        colorText: Colors.red[700],
                        icon: Icon(
                          Icons.warning_rounded,
                          color: Colors.red[700],
                        ),
                        borderRadius: 12,
                        margin: const EdgeInsets.all(16),
                      );
                      return;
                    }

                    final data = {
                      'nama': namaController.text,
                      'alamat': alamatController.text,
                      'telepon': teleponController.text,
                    };

                    if (isEdit) {
                      controller.updateBaberman(item['uid'], data);
                    } else {
                      controller.addBaberman(
                        nama: namaController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        alamat: alamatController.text,
                        telepon: teleponController.text,
                      );
                    }

                    Get.back();

                    Get.snackbar(
                      'Berhasil',
                      isEdit
                          ? 'Data baberman berhasil diperbarui'
                          : 'Baberman berhasil ditambahkan',
                      backgroundColor: Colors.green[50],
                      colorText: Colors.green[700],
                      icon: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green[700],
                      ),
                      borderRadius: 12,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Simpan Perubahan' : 'Tambah Baberman',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.deepPurple[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.deepPurple[400]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
