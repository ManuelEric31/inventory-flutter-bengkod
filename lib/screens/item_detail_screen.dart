import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/database/databasehelper.dart';
import 'package:inventory_management/models/history.dart';
import 'package:inventory_management/models/item.dart';
import 'package:inventory_management/screens/add_history_screen.dart';
import 'package:inventory_management/widgets/placeholder/placeholdersmall_history.dart';

class ItemDetailScreen extends StatefulWidget {
  final Barang barang;

  const ItemDetailScreen({super.key, required this.barang});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  List<Riwayat> _riwayatList = [];
  int totalStok = 0;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final dbHelper = DatabaseHelper();
      final data = await dbHelper.getBarangById(widget.barang.idBarang!);
      debugPrint(data.toString());
      setState(() {
        totalStok = data!['stok'];
      });
    } catch (e, stacktrace) {
      debugPrint('Error fetching riwayat: $e\n$stacktrace');
    }
  }

  Future<void> _fetchRiwayat() async {
    try {
      final dbHelper = DatabaseHelper();
      final data = await dbHelper.getRiwayatByBarangId(widget.barang.idBarang!);
      setState(() {
        _riwayatList = data.map((e) => Riwayat.fromMap(e)).toList();
      });
    } catch (e, stacktrace) {
      debugPrint('Error fetching riwayat: $e\n$stacktrace');
    }
  }

  String _formatHarga(double harga) {
    if (harga == harga.toInt()) {
      return NumberFormat("#,###", "id_ID").format(harga.toInt());
    } else {
      return NumberFormat("#,###.##", "id_ID").format(harga);
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchDetail();
    _fetchRiwayat();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.barang.namaBarang,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.barang.foto.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.barang.foto),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image_not_supported, size: 200),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 0, 0),
                      Color.fromARGB(255, 0, 22, 69),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Category : ', widget.barang.kategori),
                    const SizedBox(height: 12),
                    _buildInfoColumn('Description :', widget.barang.deskripsi),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        'Price : ', 'Rp${_formatHarga(widget.barang.harga)}'),
                    const SizedBox(height: 12),
                    _buildInfoRow('Stock : ', '$totalStok'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Item History',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 28, 53),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 28, 53),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddHistoryScreen(barang: widget.barang),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            'Add History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              _riwayatList.isEmpty
                  ? const PlaceholdersmallNoItem()
                  : SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ListView.builder(
                          itemCount: _riwayatList.length,
                          itemBuilder: (context, index) {
                            final riwayat =
                                _riwayatList.reversed.toList()[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                height: 120,
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/framebackgroundriwayat.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Center(
                                      child: ListTile(
                                        title: Text(
                                          '${riwayat.tanggal} \nQuantity : ${riwayat.stok}',
                                          style: const TextStyle(),
                                        ),
                                        subtitle: Text(
                                          riwayat.jenisTransaksi,
                                          style: TextStyle(
                                            color: riwayat.jenisTransaksi ==
                                                    'Masuk'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}
