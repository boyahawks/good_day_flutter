// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:good_day/screen/motoris/Detail_kedai.dart';
import 'package:good_day/screen/motoris/Informasi_selesai_kunjungan.dart';
import 'package:good_day/screen/motoris/Produk.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class Laporan extends StatefulWidget {
  @override
  State<Laporan> createState() => _LaporaninState();

  var kedai;
  Laporan(this.kedai);
}

class _LaporaninState extends State<Laporan> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _LaporaninState createState() => _LaporaninState();

  var dataKedai = [];

  File? fotoBranding;
  var base64FotoBranding;
  File? fotoHanger;
  var base64FotoHanger;
  File? fotoTandaTerima;
  var base64FotoTandaTerima;
  File? fotoTokoTutup;
  var base64FotoTokoTutup;

  bool pointBranding = false;
  bool pointHanger = false;
  bool pointTandaTerima = false;
  bool pointTokoTutup = false;

  int nilaiBranding = 0;
  int nilaiHanger = 0;
  String statusToko = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: logo(),
              ),
              Expanded(
                flex: 65,
                child: viewLaporan(),
              ),
              Expanded(
                flex: 15,
                child: gambarSaset(),
              )
              // SizedBox(
              //   height: 130,
              // ),
              // viewLaporan(),
            ],
          ),
        )
      ],
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI

  gantiTrue(title, value) {
    setState(() {
      if (title == 'branding') {
        pointBranding = value;
      } else if (title == 'hanger') {
        pointHanger = value;
      } else if (title == 'tandaterima') {
        pointTandaTerima = value;
      } else if (title == 'tokotutup') {
        pointTokoTutup = value;
      }
    });
  }

  // foto 1
  Future getImageBranding() async {
    final getFoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      fotoBranding = File(getFoto!.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64FotoBranding = base64Encode(bytes);
    });
  }

  Future getImageHanger() async {
    final getFoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      fotoHanger = File(getFoto!.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64FotoHanger = base64Encode(bytes);
    });
  }

  Future getImageTandaTerima() async {
    final getFoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      fotoTandaTerima = File(getFoto!.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64FotoTandaTerima = base64Encode(bytes);
      pointTandaTerima = true;
    });
  }

  Future getImageTokoTutup() async {
    final getFoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      fotoTokoTutup = File(getFoto!.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64FotoTokoTutup = base64Encode(bytes);
    });
  }

  aksiKirim() async {
    if (base64FotoBranding != null &&
        base64FotoHanger != null &&
        base64FotoTandaTerima != null &&
        base64FotoTokoTutup != null) {
      var idKedai = widget.kedai;
      setState(() {
        simpanDataLaporan();
        if (pointBranding == true) {
          nilaiBranding += 100;
        } else {
          nilaiBranding += 0;
        }
        if (pointHanger == true) {
          nilaiHanger += 100;
        } else {
          nilaiHanger += 0;
        }
        if (pointTokoTutup == false) {
          statusToko = 'buka';
        } else {
          statusToko = 'tutup';
        }
        var idKedai = widget.kedai;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InformasiSelesaiKunjungan(
                  idKedai, nilaiBranding, nilaiHanger, statusToko, 0)),
        );
      });
    } else {
      var alert = "HARAP LENGKAPI GAMBAR";
      WidgetAlert.showAlertUmum(context, alert);
    }
  }

  simpanDataLaporan() async {
    try {
      var formData = dio.FormData.fromMap({
        'id_kedai': widget.kedai,
        'laporan_branding': base64FotoBranding,
        'laporan_hanger': base64FotoHanger,
        'laporan_tandaterima': base64FotoTandaTerima,
        'laporan_tokotutup': base64FotoTokoTutup,
      });
      var response = await dio.Dio().post(
        Api.uploadLaporan,
        data: formData,
      );
      var status = response.data['status'];
      var message = response.data['message'];
      print(status);
      print(message);
    } on Exception catch (e) {
      setState(() {
        Navigator.of(context).pop(true);
        print(e);
        var alert = "terjadi kesalahan...harap hubungi admin";
        WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget logo() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
      ),
    );
  }

  Widget gambarSaset() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Image.asset("assets/gambar/ic_saset_web.png"),
      ),
    );
  }

  Widget viewLaporan() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            viewBranding(),
            SizedBox(
              height: 10,
            ),
            viewHanger(),
            SizedBox(
              height: 10,
            ),
            viewTandaTerima(),
            SizedBox(
              height: 10,
            ),
            viewKedaiTutup(),
            SizedBox(
              height: 10,
            ),
            buttonKirim(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget viewBranding() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foto Kerapihan dan Kebersihan Branding",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Berikan Checklist jika rapih dan bersih.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              setState(() {
                getImageBranding();
              });
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(193, 223, 223, 223),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    fotoBranding == null
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/gambar/blur-image.jpg"),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Image.file(
                              fotoBranding!,
                              height: 200,
                            ),
                          ),
                    Center(
                      child: Container(
                        height: 230,
                        alignment: Alignment.bottomRight,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Color.fromARGB(255, 0, 0, 0)),
                          child: Transform.scale(
                            scale: 2.0,
                            child: Container(
                              margin: EdgeInsets.only(right: 3),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: pointBranding,
                                onChanged: (value) {
                                  setState(() {
                                    var title = 'branding';
                                    gantiTrue(title, value);
                                  });
                                  ;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget viewHanger() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foto Kerapihan dan Kebersihan Hanger",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Berikan Checklist jika rapih dan bersih.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              getImageHanger();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(193, 223, 223, 223),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    fotoHanger == null
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/gambar/blur-image.jpg"),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Image.file(
                              fotoHanger!,
                              height: 200,
                            ),
                          ),
                    Center(
                      child: Container(
                        height: 230,
                        alignment: Alignment.bottomRight,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Color.fromARGB(255, 0, 0, 0)),
                          child: Transform.scale(
                            scale: 2.0,
                            child: Container(
                              margin: EdgeInsets.only(right: 3),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: pointHanger,
                                onChanged: (value) {
                                  setState(() {
                                    var title = 'hanger';
                                    gantiTrue(title, value);
                                  });
                                  ;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget viewTandaTerima() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foto Kerapihan dan Kebersihan Tanda Terima",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              getImageTandaTerima();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(193, 223, 223, 223),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    fotoTandaTerima == null
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/gambar/blur-image.jpg"),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Image.file(
                              fotoTandaTerima!,
                              height: 200,
                            ),
                          ),
                    Center(
                      child: Container(
                        height: 230,
                        alignment: Alignment.bottomRight,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Color.fromARGB(255, 0, 0, 0)),
                          child: Transform.scale(
                            scale: 2.0,
                            child: Container(
                              margin: EdgeInsets.only(right: 3),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: pointTandaTerima,
                                onChanged: (value) {
                                  setState(() {
                                    var title = 'tandaterima';
                                    gantiTrue(title, value);
                                  });
                                  ;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget viewKedaiTutup() {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foto Kerapihan dan Kebersihan Toko Tutup",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Berikan Checklist jika toko tutup.",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              getImageTokoTutup();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(193, 223, 223, 223),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    fotoTokoTutup == null
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/gambar/blur-image.jpg"),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Image.file(
                              fotoTokoTutup!,
                              height: 200,
                            ),
                          ),
                    Center(
                      child: Container(
                        height: 230,
                        alignment: Alignment.bottomRight,
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor:
                                  Color.fromARGB(255, 0, 0, 0)),
                          child: Transform.scale(
                            scale: 2.0,
                            child: Container(
                              margin: EdgeInsets.only(right: 3),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: pointTokoTutup,
                                onChanged: (value) {
                                  setState(() {
                                    var title = 'tokotutup';
                                    gantiTrue(title, value);
                                  });
                                  ;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget buttonKirim() {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(242, 240, 240, 240),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            aksiKirim();
          });
        },
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "Kirim Laporan",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
