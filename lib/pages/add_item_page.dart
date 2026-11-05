
import 'package:flutter/material.dart';

import '../models/item_model.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _locationController =
      TextEditingController();

  final TextEditingController _reporterController =
      TextEditingController();

  String selectedCategory = 'Elektronik';
  String selectedType = 'Hilang';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final Color primaryColor = const Color(0xFF2563EB);

  final List<String> categories = [
    'Elektronik',
    'Aksesoris',
    'Dokumen',
    'Kunci',
    'Tas',
    'Perlengkapan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _reporterController.dispose();
    super.dispose();
  }

  // MEMILIH TANGGAL
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // MEMILIH WAKTU
  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // MENYIMPAN LAPORAN
  void _saveItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final date =
        '${selectedDate.day.toString().padLeft(2, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.year}';

    final time = selectedTime.format(context);

    final newItem = Item(
      name: _nameController.text.trim(),
      category: selectedCategory,
      type: selectedType,
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      date: '$date, $time',
      reporter: _reporterController.text.trim(),
      image: 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/500/300',
    );

    // Mengirim data ke halaman Home
    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1E293B),
          ),
        ),
        title: const Text(
          'Tambah Laporan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),

      // FORMULIR
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // INFORMASI FORMULIR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 38,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buat Laporan Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lengkapi informasi barang dengan benar.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // JENIS LAPORAN
              _buildLabel('Jenis Laporan'),

              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      'Hilang',
                      Icons.search_off_rounded,
                      const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      'Ditemukan',
                      Icons.check_circle_outline,
                      const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // NAMA BARANG
              _buildLabel('Nama Barang'),

              _buildTextField(
                controller: _nameController,
                hint: 'Contoh: Dompet hitam',
                icon: Icons.inventory_2_outlined,
              ),

              const SizedBox(height: 18),

              // KATEGORI
              _buildLabel('Kategori Barang'),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: _inputDecoration(
                  hint: 'Pilih kategori',
                  icon: Icons.category_outlined,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              // DESKRIPSI
              _buildLabel('Deskripsi Barang'),

              _buildTextField(
                controller: _descriptionController,
                hint: 'Jelaskan ciri-ciri barang...',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 18),

              // LOKASI
              _buildLabel('Lokasi Kehilangan / Penemuan'),

              _buildTextField(
                controller: _locationController,
                hint: 'Contoh: Perpustakaan Kampus',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 18),

              // TANGGAL
              _buildLabel('Tanggal Kejadian'),

              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                          '${selectedDate.month.toString().padLeft(2, '0')}/'
                          '${selectedDate.year}',
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // WAKTU
              _buildLabel('Waktu Kejadian'),

              InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedTime.format(context),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // NAMA PELAPOR
              _buildLabel('Nama Pelapor'),

              _buildTextField(
                controller: _reporterController,
                hint: 'Masukkan nama pelapor',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Simpan Laporan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET LABEL
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  // WIDGET TEXT FIELD
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(
        hint: hint,
        icon: icon,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bagian ini wajib diisi';
        }
        return null;
      },
    );
  }

  // DESAIN INPUT
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: primaryColor,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  // TOMBOL JENIS LAPORAN
  Widget _buildTypeButton(
    String type,
    IconData icon,
    Color color,
  ) {
    final bool isSelected = selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          selectedType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),
            const SizedBox(height: 6),
            Text(
              type,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
