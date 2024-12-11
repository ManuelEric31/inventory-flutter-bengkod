import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/database/databasehelper.dart';
import 'package:inventory_management/models/item.dart';
import 'package:inventory_management/widgets/chips/category_chip.dart';
import 'package:inventory_management/widgets/textfields/item_description_textfield.dart';
import 'package:inventory_management/widgets/textfields/item_name_textfield.dart';
import 'package:inventory_management/widgets/textfields/item_price_textfield.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  File? selectedImage;
  final TextEditingController controllerTypedItemName = TextEditingController();
  final TextEditingController controllerTypedPriceName =
      TextEditingController();
  final TextEditingController controllerTypedDescriptionName =
      TextEditingController();
  String selectedCategory = "";

  Future<void> _pickImageOption() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: source);
      if (returnedImage != null) {
        setState(() {
          selectedImage = File(returnedImage.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil gambar'),
        ),
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _clearForm() {
    setState(() {
      controllerTypedItemName.clear();
      controllerTypedPriceName.clear();
      controllerTypedDescriptionName.clear();
      selectedCategory = "";
      selectedImage = null;
    });
  }

  void _insertItemOnDb() async {
    if (controllerTypedItemName.text.isEmpty ||
        controllerTypedPriceName.text.isEmpty ||
        controllerTypedDescriptionName.text.isEmpty ||
        selectedCategory.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final barang = Barang(
      namaBarang: controllerTypedItemName.text,
      deskripsi: controllerTypedDescriptionName.text,
      kategori: selectedCategory,
      harga: double.parse(controllerTypedPriceName.text),
      foto: selectedImage?.path ?? '',
      stok: 0,
    );

    await DatabaseHelper().insertBarang(barang.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item berhasil ditambahkan'),
        backgroundColor: Colors.green,
      ),
    );

    _clearForm();
  }

  @override
  void dispose() {
    controllerTypedItemName.dispose();
    controllerTypedPriceName.dispose();
    controllerTypedDescriptionName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 0, 28, 53),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: GestureDetector(
                  onTap: _pickImageOption,
                  child: selectedImage == null
                      ? Container(
                          width: 320,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 34.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Tap to upload image",
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedImage!.path),
                            width: 320,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Name'),
                          ItemNameTextfield(
                              controllerTyped: controllerTypedItemName),
                          const Text('Price'),
                          ItemPriceTextfield(
                              controllerTyped: controllerTypedPriceName),
                          const Text('Category'),
                          CategoryChipWidget(
                              selectedCategory: selectedCategory,
                              onCategorySelected: _onCategorySelected),
                          const Text('Description'),
                          ItemDescriptionTextfield(
                              controllerTyped: controllerTypedDescriptionName),
                          SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                              height: 48,
                              onPressed: _insertItemOnDb,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
