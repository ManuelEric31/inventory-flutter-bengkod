class Riwayat {
  int? idRiwayat;
  int idBarang;
  String jenisTransaksi;
  int stok;
  String tanggal;

  Riwayat({
    this.idRiwayat,
    required this.idBarang,
    required this.jenisTransaksi,
    required this.stok,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_riwayat': idRiwayat,
      'id_barang': idBarang,
      'jenis_transaksi': jenisTransaksi,
      'stok': stok,
      'tanggal': tanggal,
    };
  }

  static Riwayat fromMap(Map<String, dynamic> map) {
    return Riwayat(
      idRiwayat: map['id_riwayat'],
      idBarang: map['id_barang'],
      jenisTransaksi: map['jenis_transaksi'],
      stok: map['stok'],
      tanggal: map['tanggal'],
    );
  }
}
