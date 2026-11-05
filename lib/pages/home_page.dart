
import 'package:flutter/material.dart';

import '../data/item_data.dart';
import '../models/item_model.dart';
import 'add_item_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryColor = const Color(0xFF2563EB);

  // Menghitung jumlah barang berdasarkan jenis laporan
  int get totalHilang =>
      itemList.where((item) => item.type == 'Hilang').length;

  int get totalDitemukan =>
      itemList.where((item) => item.type == 'Ditemukan').length;

  // Membuka halaman tambah laporan
  Future<void> _openAddPage() async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddItemPage(),
      ),
    );

    if (!mounted) return;

    if (newItem != null) {
      setState(() {
        itemList.insert(0, newItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Membuka halaman detail barang
  void _openDetail(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),

        // HEADER APLIKASI
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'FindIt',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF334155),
                size: 27,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // ISI HALAMAN
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SAPAAN PENGGUNA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo, Teman FindIt! 👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Temukan barang yang hilang di sekitarmu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // RINGKASAN JUMLAH BARANG
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Barang Hilang',
                      total: totalHilang,
                      icon: Icons.search_off_rounded,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Ditemukan',
                      total: totalDitemukan,
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // JUDUL DAFTAR
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Informasi Barang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // TAB BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'Barang Hilang'),
                  Tab(text: 'Ditemukan'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // TAB VIEW
            Expanded(
              child: TabBarView(
                children: [
                  // LISTVIEW.BUILDER
                  _buildItemList(
                    'Hilang',
                    useSeparated: false,
                  ),

                  // LISTVIEW.SEPARATED
                  _buildItemList(
                    'Ditemukan',
                    useSeparated: true,
                  ),
                ],
              ),
            ),
          ],
        ),

        // TOMBOL TAMBAH LAPORAN
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddPage,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text(
            'Buat Laporan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // WIDGET KARTU RINGKASAN
  Widget _buildSummaryCard({
    required String title,
    required int total,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(height: 12),
          Text(
            '$total',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // MENAMPILKAN DAFTAR BARANG
  Widget _buildItemList(
    String type, {
    required bool useSeparated,
  }) {
    final filteredItems = itemList
        .where((item) => item.type == type)
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 55,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'Belum ada laporan barang $type.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    if (useSeparated) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 90),
        itemCount: filteredItems.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildItemCard(filteredItems[index]);
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 90),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildItemCard(filteredItems[index]),
        );
      },
    );
  }

  // WIDGET KARTU BARANG
  Widget _buildItemCard(Item item) {
    final bool isLost = item.type == 'Hilang';

    return InkWell(
      onTap: () => _openDetail(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [

              // GAMBAR BARANG DARI INTERNET
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.image,
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 95,
                      height: 95,
                      color: const Color(0xFFE8F0FF),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 35,
                        color: primaryColor,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 13),

              // INFORMASI BARANG
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isLost
                            ? const Color(0xFFFFE8E8)
                            : const Color(0xFFE5F8EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.type,
                        style: TextStyle(
                          color: isLost
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF15803D),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
