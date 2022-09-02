import 'package:flutter/material.dart';
import 'package:good_day/screen/agen/Detail_kedai_grosir.dart';
import 'package:good_day/screen/agen/Informasi_kedai_wa.dart';
import 'package:good_day/screen/agen/Informasi_selesai_pembelian.dart';
import 'package:good_day/screen/agen/Kedai_grosir.dart';
import 'package:good_day/screen/agen/List_pembelian_kedai.dart';
import 'package:good_day/screen/motoris/Informasi_selesai_kunjungan.dart';
import 'package:good_day/screen/motoris/Produk.dart';
import 'package:good_day/screen/motoris/hadiah/Hadiah.dart';
import 'package:good_day/screen/motoris/informasi/Informasi.dart';
import 'package:good_day/screen/motoris/konfirmasi/Konfirmasi_pembelian.dart';
import 'package:good_day/widget/Alert.dart';
import 'package:splashscreen/splashscreen.dart';

// screens
import 'package:good_day/screen/Login.dart';
import 'package:good_day/screen/agen/Dashboard_agen.dart';
import 'package:good_day/screen/motoris/Cluster.dart';
import 'package:good_day/screen/motoris/Dashboard.dart';
import 'package:good_day/screen/motoris/Detail_kedai.dart';
import 'package:good_day/screen/motoris/Kedai.dart';
import 'package:good_day/screen/motoris/Kunjungan.dart';
import 'package:good_day/screen/motoris/Laporan.dart';
import 'package:good_day/screen/motoris/Rayon.dart';
import 'package:good_day/utils/Local_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage.prefs = await SharedPreferences.getInstance();
  await Permission.camera.request();
  await Permission.location.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final routes = <String, WidgetBuilder>{
    "/login": (BuildContext context) => Login(),
    "/dashboardAgen": (BuildContext context) => DashboardAgen(),
    "/dashboardMotoris": (BuildContext context) => DashboardMotoris(),
    "/cluster": (BuildContext context) => Cluster(),
    "/rayon": (BuildContext context) => Rayon(''),
    "/kedai": (BuildContext context) => Kedai('', ''),
    "/detailKedai": (BuildContext context) => DetailKedai(''),
    "/kunjungan": (BuildContext context) => Kunjungan(''),
    "/laporan": (BuildContext context) => Laporan(''),
    "/produk": (BuildContext context) => Produk('', 0, 0, ''),
    "/informasiSelesaiKunjungan": (BuildContext context) =>
        InformasiSelesaiKunjungan('', 0, 0, '', 0),
    "/kedaiGrosir": (BuildContext context) => KedaiGrosir(''),
    "/informasiKedaiWa": (BuildContext context) => InformasiKedaiWa(''),
    "/listPembelianKedai": (BuildContext context) => ListPembelianKedai(),
    "/detailKedaiGrosir": (BuildContext context) => DetailKedaiGrosir(''),
    "/informasiSelesaiPembelian": (BuildContext context) =>
        InformasiSelesaiPembelian('', 0, 0, '', 0),
    "/konfirmasiPembelian": (BuildContext context) => KonfirmasiPembelian(),
    "/hadiah": (BuildContext context) => Hadiah(),
    "/informasiMotoris": (BuildContext context) => InformasiMotoris(),
    // "/posm": (BuildContext context) => Posm(),
    // "/addstokinout": (BuildContext context) => PosmInOut(),
    // "/stok": (BuildContext context) => Stok(),
    // "/dokumentasi": (BuildContext context) => Dokumentasi(),
    // "/activity": (BuildContext context) => Activity(),
    // "/izin": (BuildContext context) => Izin(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KEIKO',
        theme: ThemeData(fontFamily: 'OpenSans'),
        debugShowCheckedModeBanner: false,
        routes: routes,
        // builder: EasyLoading.init(),
        home: SplashScreen(
            seconds: 5,
            navigateAfterSeconds: Login(),
            title: const Text(
              'KEIKO',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            image: Image.asset("assets/gambar/ic_logo_web.png"),
            photoSize: 200.0,
            backgroundColor: const Color.fromARGB(255, 156, 8, 8),
            // styleTextUnderTheLoader: new TextStyle(),
            loaderColor: Colors.white));
  }
}
