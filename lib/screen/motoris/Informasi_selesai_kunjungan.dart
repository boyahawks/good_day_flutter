// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations, prefer_if_null_operators

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/agen/Dashboard_agen.dart';
import 'package:good_day/screen/motoris/Dashboard.dart';
import 'package:good_day/screen/motoris/Rayon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/Motoris.dart';
import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class InformasiSelesaiKunjungan extends StatefulWidget {
  @override
  State<InformasiSelesaiKunjungan> createState() =>
      _InformasiSelesaiKunjunganinState();

  var kedai, pointBranding, pointHanger, statusKedai, pointPembelian;
  InformasiSelesaiKunjungan(
    this.kedai,
    this.pointBranding,
    this.pointHanger,
    this.statusKedai,
    this.pointPembelian,
  );
}

class _InformasiSelesaiKunjunganinState
    extends State<InformasiSelesaiKunjungan> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _InformasiSelesaiKunjunganinState createState() =>
      _InformasiSelesaiKunjunganinState();

  final controller = Get.put(MotorisController());

  var detailKedai = [];

  var pointTotal = 0;
  var pointSaatIni = 0;

  var status_branding;
  var status_hanger;

  var jumlah_p1;
  var jumlah_p2;
  var jumlah_p3;
  var jumlah_p4;
  var jumlah_p5;
  var jumlah_p6;
  var jumlah_p7;
  var jumlah_pbk;

  @override
  void initState() {
    pointTotal =
        widget.pointPembelian + widget.pointBranding + widget.pointHanger;
    getDataKedai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage("assets/gambar/background-mobile.png"),
                      fit: BoxFit.cover)),
              child: detailKedai.isEmpty
                  ? Center(
                      child: Container(
                          margin: const EdgeInsets.only(top: 300),
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )),
                    )
                  : Column(
                      children: <Widget>[
                        Expanded(
                          flex: 45,
                          child: header(),
                        ),
                        Expanded(
                          flex: 55,
                          child: viewInformasi(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 70,
          child: Stack(
            children: [
              FloatingActionButton(
                child: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 35,
                ),
                backgroundColor: Colors.green.shade800,
                onPressed: () {
                  setState(() {
                    kirimPesanWa();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI

  getDataKedai() async {
    try {
      var formData = dio.FormData.fromMap({'id_kedai': widget.kedai});
      var response = await dio.Dio().post(
        Api.detailKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          detailKedai = data;
          pointSaatIni = int.parse(data[0]['point']);
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
    }
  }

  validasiKirim() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Center(
                  child: Text(
                    "Simpan informasi dan lanjutkan kunjungan ?",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  aksiKirimLaporan();
                });
              },
            )
          ],
        );
      },
    );
  }

  aksiKirimLaporan() async {
    WidgetAlert.showLoadingIndicator(context);
    for (var i = 0; i < controller.listProdukTerpilih.length; i++) {
      if (controller.listProdukTerpilih[i]['kode'] == 'p1') {
        jumlah_p1 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p2') {
        jumlah_p2 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p3') {
        jumlah_p3 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p4') {
        jumlah_p4 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p5') {
        jumlah_p5 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p6') {
        jumlah_p6 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'p7') {
        jumlah_p7 = controller.listProdukTerpilih[i]['jumlahPilih'];
      } else if (controller.listProdukTerpilih[i]['kode'] == 'pbk') {
        jumlah_pbk = controller.listProdukTerpilih[i]['jumlahPilih'];
      }
    }

    if (widget.pointBranding == 100) {
      status_branding = "baik";
    } else {
      status_branding = "buruk";
    }
    if (widget.pointHanger == 100) {
      status_hanger = "baik";
    } else {
      status_hanger = "buruk";
    }
    var id_pemilik = detailKedai[0]['id_kedai'];
    var id_motoris = AppData.userId;
    var id_cluster = detailKedai[0]['id_cluster'];
    var id_rayon = detailKedai[0]['id_rayon'];
    var id_kedai = detailKedai[0]['id_kedai'];

    var point_pembelian = widget.pointPembelian;

    var getProduk1 = jumlah_p1 == null ? "0" : jumlah_p1;
    var getProduk2 = jumlah_p2 == null ? "0" : jumlah_p2;
    var getProduk3 = jumlah_p3 == null ? "0" : jumlah_p3;
    var getProduk4 = jumlah_p4 == null ? "0" : jumlah_p4;
    var getProduk5 = jumlah_p5 == null ? "0" : jumlah_p5;
    var getProduk6 = jumlah_p6 == null ? "0" : jumlah_p6;
    var getProduk7 = jumlah_p7 == null ? "0" : jumlah_p7;
    var getBungkus = jumlah_pbk == null ? "0" : jumlah_pbk;

    // print("id_pemilik $id_pemilik");
    // print("id_motoris $id_motoris");
    // print("id_cluster $id_cluster");
    // print("id_rayon $id_rayon");
    // print("id_kedai $id_kedai");
    // print("status_branding $status_branding");
    // print("status_hanger $status_hanger");
    // print("getProduk1 $getProduk1");
    // print("getProduk2 $getProduk2");
    // print("getProduk3 $getProduk3");
    // print("getProduk4 $getProduk4");
    // print("getProduk5 $getProduk5");
    // print("getProduk6 $getProduk6");
    // print("getProduk7 $getProduk7");
    // print("getBungkus $getBungkus");
    // print("point_pembelian $point_pembelian");

    try {
      var formData = dio.FormData.fromMap({
        'id_pemilik': id_pemilik,
        'id_motoris': id_motoris,
        'id_cluster': id_cluster,
        'id_rayon': id_rayon,
        'id_kedai': id_kedai,
        'status_branding': status_branding,
        'status_hanger': status_hanger,
        'jumla_p1': getProduk1,
        'jumla_p2': getProduk2,
        'jumla_p3': getProduk3,
        'jumla_p4': getProduk4,
        'jumla_p5': getProduk5,
        'jumla_p6': getProduk6,
        'jumla_p7': getProduk7,
        'jumla_pbk': getBungkus,
        'point_pembelian': pointTotal,
      });
      var response = await dio.Dio().post(
        Api.simpanInformasiKunjungan,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      setState(() {
        if (status == true) {
          var id_motoris = AppData.userId;
          kirimLaporanKunjungan(
            id_cluster,
            id_rayon,
            id_kedai,
            id_motoris,
          );
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } catch (e) {
      print(e);
      // WidgetAlert.showAlertUmum(context, e);
    }
  }

  kirimLaporanKunjungan(
    id_cluster,
    id_rayon,
    id_kedai,
    id_motoris,
  ) async {
    try {
      var formData = dio.FormData.fromMap({
        'id_cluster': id_cluster,
        'id_rayon': id_rayon,
        'id_kedai': id_kedai,
        'id_motoris': id_motoris,
        'status_kedai_kunjungan': widget.statusKedai
      });
      var response = await dio.Dio().post(
        Api.simpanStatusKunjungan,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);
      var berhasil = "Data pembelian berhasil di kirim";
      WidgetAlert.showToast(context, berhasil);
      setState(() {
        if (status == true) {
          setState(() {
            controller.listProdukTerpilih.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardMotoris()),
            );
          });
        } else {
          WidgetAlert.showAlertUmum(context, message);
          print("$message");
        }
      });
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
    }
  }

  kirimPesanWa() async {
    try {
      var response = await dio.Dio().get(
        Api.getPesanWa,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      print(data);

      var isiPesan = data[0]['isi_pesan'];
      var gabunganPesan =
          "$isiPesan\nPoint Kedai ${detailKedai[0]['nama_kedai']}\n$pointSaatIni POINT";
      var notujuan = detailKedai[0]['no_telpon'];
      var filternohp = notujuan.substring(1);
      var kodeNegara = 62;
      var gabungNohp = "$kodeNegara$filternohp";
      print(gabunganPesan);
      print(gabungNohp);

      var whatsappURl_android =
          "whatsapp://send?phone=" + gabungNohp + "&text=" + gabunganPesan;
      var whatappURL_ios =
          "https://wa.me/$gabungNohp?text=${Uri.parse(gabunganPesan)}";

      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappURL_ios)) {
          await launch(whatappURL_ios, forceSafariVC: false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunch(whatsappURl_android)) {
          await launch(whatsappURl_android);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("whatsapp no installed")));
        }
      }
      ;
    } catch (e) {
      print(e);
      WidgetAlert.showAlertUmum(context, e);
    }
  }

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 20,
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Point Kedai Hari Ini",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: Center(
            child: logo(),
          ),
        ),
        Expanded(
          flex: 40,
          child: Center(
            child: gambarSaset(),
          ),
        ),
      ],
    );
  }

  Widget logo() {
    return SizedBox(
      height: 120,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
      ),
    );
  }

  Widget gambarSaset() {
    return SizedBox(
      height: 120,
      child: Center(
        child: Image.asset("assets/gambar/ic_saset_web.png"),
      ),
    );
  }

  Widget viewInformasi() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Selamat Kedai ${detailKedai[0]['nama_kedai']} mendapatkan",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1.5,
            color: Colors.white,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 80,
                        child: Text(
                          "Kerapihan Branding",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Text(
                          "${widget.pointBranding}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 80,
                        child: Text(
                          "Kerapihan Hanger",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Text(
                          "${widget.pointHanger}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 80,
                        child: Text(
                          "Pembelian",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Text(
                          "${widget.pointPembelian}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 1.5,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 80,
                        child: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Text(
                          "${pointTotal}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Point Kedai ${detailKedai[0]['nama_kedai']} Saat ini",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              // ignore: unnecessary_brace_in_string_interps
              "${pointSaatIni}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () => validasiKirim(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text("Simpan"),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
