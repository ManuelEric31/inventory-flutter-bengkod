import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/database/databasehelper.dart';
import 'package:inventory_management/models/item.dart';
import 'package:inventory_management/widgets/textfields/date_textfield.dart';
import 'package:inventory_management/widgets/textfields/item_quantity_textfield.dart';

class AddHistoryScreen extends StatefulWidget {
  final Barang barang;
  const AddHistoryScreen({super.key, required this.barang});

  @override
  State<AddHistoryScreen> createState() => _AddHistoryScreenState();
}

class _AddHistoryScreenState extends State<AddHistoryScreen> {
  final TextEditingController controllerJumlah = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final DateFormat formatter = DateFormat.yMd();
  String selectedJenisTransaksi = 'Masuk';

  @override
  void dispose() {
    controllerJumlah.dispose();
    controllerDate.dispose();
    super.dispose();
  }

  void _insertRiwayatToDb() async {
    if (controllerJumlah.text.isEmpty || controllerDate.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await DatabaseHelper().addRiwayat(
        widget.barang.idBarang!,
        selectedJenisTransaksi,
        int.parse(controllerJumlah.text),
        controllerDate.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Riwayat berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan riwayat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah Riwayat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quantity'),
            ItemQuantityTextfield(controllerTyped: controllerJumlah),
            const Text('Date'),
            DateTextfield(
              controllerDate: controllerDate,
            ),
            const Text('Transaction Type'),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: DropdownButton<String>(
                  menuWidth: double.infinity,
                  value: selectedJenisTransaksi,
                  items: ['Masuk', 'Keluar'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedJenisTransaksi = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                height: 48,
                onPressed: _insertRiwayatToDb,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color.fromARGB(255, 0, 28, 53),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
