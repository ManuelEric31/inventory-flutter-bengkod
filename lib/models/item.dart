class Barang {
  int? idBarang;
  String namaBarang;
  String deskripsi;
  String kategori;
  double harga;
  String foto;
  int stok;

  Barang({
    this.idBarang,
    required this.namaBarang,
    required this.deskripsi,
    required this.kategori,
    required this.harga,
    required this.foto,
    required this.stok,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_barang': idBarang,
      'nama_barang': namaBarang,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'harga': harga,
      'foto': foto,
      'stok': stok,
    };
  }

  static Barang fromMap(Map<String, dynamic> map) {
    return Barang(
      idBarang: map['id_barang'],
      namaBarang: map['nama_barang'],
      deskripsi: map['deskripsi'],
      kategori: map['kategori'],
      harga: (map['harga'] is int)
          ? (map['harga'] as int).toDouble()
          : map['harga'] ?? 0.0,
      foto: map['foto'],
      stok: map['stok'] ?? 0,
    );
  }
}
