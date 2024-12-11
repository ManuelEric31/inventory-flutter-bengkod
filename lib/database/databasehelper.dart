import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'inventory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE barang (
            id_barang INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_barang TEXT NOT NULL,
            deskripsi TEXT,
            kategori TEXT,
            harga REAL NOT NULL,
            stok INTEGER NOT NULL DEFAULT 0,
            foto TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE riwayat (
            id_riwayat INTEGER PRIMARY KEY AUTOINCREMENT,
            id_barang INTEGER NOT NULL,
            jenis_transaksi TEXT NOT NULL,
            stok INTEGER NOT NULL,
            tanggal TEXT NOT NULL,
            FOREIGN KEY (id_barang) REFERENCES barang (id_barang)
          )
        ''');
      },
    );
  }

  Future<int> insertBarang(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('barang', data);
  }

  Future<List<Map<String, dynamic>>> getAllBarang() async {
    final db = await database;
    return await db.query('barang');
  }

  Future<Map<String, dynamic>?> getBarangById(int id) async {
    final db = await database;
    final result =
        await db.query('barang', where: 'id_barang = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getRiwayatByBarangId(int idBarang) async {
    final db = await database;
    return await db.query('riwayat',
        where: 'id_barang = ?', whereArgs: [idBarang], orderBy: 'tanggal DESC');
  }

  Future<void> addRiwayat(
      int idBarang, String jenisTransaksi, int jumlah, String tanggal) async {
    final db = await database;
    final barang =
        await db.query('barang', where: 'id_barang = ?', whereArgs: [idBarang]);
    if (barang.isEmpty) {
      throw Exception('Barang tidak ditemukan');
    }

    int stokSaatIni = barang.first['stok'] as int;

    if (jenisTransaksi == 'Keluar' && stokSaatIni < jumlah) {
      throw ('Stok tidak mencukupi untuk transaksi keluar');
    }

    await db.insert('riwayat', {
      'id_barang': idBarang,
      'jenis_transaksi': jenisTransaksi,
      'stok': jumlah,
      'tanggal': tanggal,
    });

    final stokBaru =
        jenisTransaksi == 'Masuk' ? stokSaatIni + jumlah : stokSaatIni - jumlah;

    await db.update('barang', {'stok': stokBaru},
        where: 'id_barang = ?', whereArgs: [idBarang]);
  }
}
