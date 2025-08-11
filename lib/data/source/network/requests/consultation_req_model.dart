import 'package:equatable/equatable.dart';

class ConsultationReqModel extends Equatable {
  final String namaLengkap;
  final String usia;

  final String alamat;
  final String keluhan;
  final String keluhanTambahan;
  final String riwayatPenyakit;
  final String pengobatanBerjalan;
  final String photoLidah;
  final String alamatPengiriman;
  final String noWA ;

  const ConsultationReqModel({
    required this.namaLengkap,
    required this.usia,
    required this.alamat,
    required this.keluhan,
    required this.keluhanTambahan,
    required this.riwayatPenyakit,
    required this.pengobatanBerjalan,
    required this.photoLidah,
    required this.alamatPengiriman,
    required this.noWA
  });

  @override
  List<Object> get props =>
      [
        namaLengkap,
        usia,
        alamat,
        keluhan,
        keluhanTambahan,
        riwayatPenyakit,
        pengobatanBerjalan,
        photoLidah,
        noWA,
        alamatPengiriman
      ];


}