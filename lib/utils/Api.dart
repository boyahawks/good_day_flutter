// ignore_for_file: file_names

import 'dart:convert';

class Api {
  // HOSTING DAN DOMAIN SILAHKAN DI SETTING

  static var basicUrl =
      "http://kedaikopigoodday.com/good-day-api/index.php/service/";

  static var controllerGambar =
      "https://kedaikopigoodday.com/good-day-api/gambar_kedai/";
  static var controllerGambarSaset =
      "https://kedaikopigoodday.com/good-day-api/saset_new/";
  static var controllerGambarHadiah =
      "https://kedaikopigoodday.com/good-day-api/assets/hadiah/";
  static var controllerAssets =
      "https://kedaikopigoodday.com/good-day-api/assets/";

  static var googleApiKey = 'AIzaSyAsGRuG2qg8d6UxNXpnlulHRNiIB6rUWgg';

  // LOGIN
  static var loginPost = basicUrl + 'Login/postUser';

  static var allCluster = basicUrl + 'All_request/all_cluster';
  static var getPesanWa = basicUrl + 'All_request/get_pesan_untuk_wa';
  static var allHadiah = basicUrl + 'All_request/all_listhadiah';
  static var allRayon = basicUrl + 'All_request/all_rayon_spesifik';
  static var allKedai = basicUrl + 'All_request/all_kedai_spesifik';
  static var allKedaiGrosir =
      basicUrl + 'All_request/all_kedai_grosir_spesifik';
  static var allProduk = basicUrl + 'All_request/all_produk';
  static var allDataKonfirmasiPembelian =
      basicUrl + 'All_request/all_pembelian_konfirmasi';
  static var allDataKonfirmasiPembelianGrosir =
      basicUrl + 'All_request/all_pembelian_konfirmasi_grosir';
  static var allKedaiSpesifikasiUserId =
      basicUrl + 'All_request/all_kedai_dengan_userid_spesifik';
  static var detailKedai = basicUrl + 'All_request/kedai_spesifik';
  static var detailGrosir = basicUrl + 'All_request/grosir_spesifik';
  static var detailCluster = basicUrl + 'All_request/cluster_spesifik';
  static var detailUser = basicUrl + 'All_request/user_spesifik';
  static var uploadLaporan = basicUrl + 'All_request/upload_laporan';
  static var simpanInformasiKunjungan =
      basicUrl + 'All_request/simpan_informasi_kunjungan';
  static var simpanStatusKunjungan =
      basicUrl + 'All_request/simpan_status_kunjungan';

  static var gantiStatusPembelian =
      basicUrl + 'All_request/ganti_status_pembelian';
  static var gantiStatusPembelianFilterData =
      basicUrl + 'All_request/ganti_status_pembelian_filter';
  static var gantiStatusPembelianFilterDataGrosir =
      basicUrl + 'All_request/ganti_status_pembelian_filter_grosir';
  static var kirimFormPengajuanHadiah =
      basicUrl + 'All_request/kirim_pengajuan_hadiah';
  static var kedaiPenukaranHadiah =
      basicUrl + 'All_request/kedai_penukaran_hadiah';
  static var kirimPenukaranHadiah =
      basicUrl + 'All_request/kirim_data_penukaran_hadiah';
  static var filterLaporanGrosir =
      basicUrl + 'All_request/filter_laporan_grosir';

  static var allHadiahSesuaiMotoris =
      basicUrl + 'All_request/hadiah_sesuai_motoris';
  static var allHadiahSesuaiMotorisFilterTanggal =
      basicUrl + 'All_request/hadiah_sesuai_motoris_filter';
  static var updateLokasiMotoris = basicUrl + 'Login/edit_latlang_user';
  static var updateDestinasiMotoris = basicUrl + 'Login/edit_latlang_destinasi';
}
