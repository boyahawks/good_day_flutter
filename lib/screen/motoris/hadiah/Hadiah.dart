// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations, prefer_is_empty

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:flutter/services.dart';
import 'package:good_day/screen/agen/Informasi_selesai_pembelian.dart';
import 'package:good_day/screen/motoris/Informasi_selesai_kunjungan.dart';
import 'package:good_day/screen/motoris/Kedai.dart';
import 'package:good_day/utils/Api.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_day/widget/Alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Hadiah extends StatefulWidget {
  @override
  State<Hadiah> createState() => _HadiahinState();
}

class _HadiahinState extends State<Hadiah> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _HadiahinState createState() => _HadiahinState();

  List allKedaiPerIdClusterDisplay = [];
  List allKedaiPerIdCluster = [];
  List kedaiTerpilih = [];

  List listHadiah = [];
  List listHadiahDisplay = [];
  List hadiahTerpilih = [];

  List kedaiPenukaran = [];
  List kedaiPenukaranDisplay = [];
  List kedaiPenukaranTerpilih = [];

  int menuTerpilih = 0;
  String namaHadiah = 'Pilih Hadiah';

  File? fotoLaporanMemberikanHadiah;
  var base64LaporanMemberikanHadiah;

  @override
  void initState() {
    getData();
    getDataHadiah();
    getKedaiPenukaran();
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
            child: allKedaiPerIdCluster.length == 0
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
                        flex: 20,
                        child: logo(),
                      ),
                      Expanded(
                        flex: 65,
                        child: viewHadiah(),
                      ),
                      Expanded(
                        flex: 15,
                        child: gambarSaset(),
                      )
                    ],
                  ),
          )
        ],
      ),
    );
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  Future getImageLaporanPemberianHadiah() async {
    final getFoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      fotoLaporanMemberikanHadiah = File(getFoto!.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64LaporanMemberikanHadiah = base64Encode(bytes);
    });
  }

  getData() async {
    try {
      var formData = dio.FormData.fromMap({"user_id": AppData.userId});
      var response = await dio.Dio().post(
        Api.allKedaiSpesifikasiUserId,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        allKedaiPerIdClusterDisplay = data;
        allKedaiPerIdCluster = data;
      });
    } catch (e) {
      setState(() {
        print(e);
        // Navigator.of(context).pop(true);
        // var alert = "Terjadi Kesalahan";
        // WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  getKedaiPenukaran() async {
    try {
      var formData = dio.FormData.fromMap({"user_id": AppData.userId});
      var response = await dio.Dio().post(
        Api.kedaiPenukaranHadiah,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        kedaiPenukaran = data;
        kedaiPenukaranDisplay = data;
      });
    } catch (e) {
      setState(() {
        print(e);
        // Navigator.of(context).pop(true);
        // var alert = "Terjadi Kesalahan";
        // WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  getDataHadiah() async {
    try {
      var response = await dio.Dio().get(
        Api.allHadiah,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");

      setState(() {
        listHadiah = data;
        listHadiahDisplay = data;
      });
    } catch (e) {
      setState(() {
        print(e);
        // Navigator.of(context).pop(true);
        // var alert = "Terjadi Kesalahan";
        // WidgetAlert.showAlertUmum(context, alert);
      });
    }
  }

  aksiKirimLaporan() async {
    if (kedaiTerpilih.isEmpty) {
      var alert = "Harap lengkapi form pengajuan bagian kedai";
      WidgetAlert.showToast(context, alert);
    } else if (hadiahTerpilih.isEmpty) {
      var alert = "Harap lengkapi form pengajuan bagian hadiah";
      WidgetAlert.showToast(context, alert);
    } else {
      WidgetAlert.showLoadingIndicator(context);
      try {
        var formData = dio.FormData.fromMap({
          "id_kedai": kedaiTerpilih[0]['id_kedai'],
          "id_user": kedaiTerpilih[0]['id_kedai'],
          "id_cluster": kedaiTerpilih[0]['id_cluster'],
          "id_rayon": kedaiTerpilih[0]['id_rayon'],
          "id_hadiah": hadiahTerpilih[0]['id_hadiah'],
          "id_motoris": AppData.userId,
        });
        var response = await dio.Dio().post(
          Api.kirimFormPengajuanHadiah,
          data: formData,
        );
        var data = response.data['data'];
        var status = response.data['status'];
        var message = response.data['message'];
        print(status);
        setState(() {
          if (status == true) {
            kedaiTerpilih.clear();
            hadiahTerpilih.clear();
            namaHadiah = 'Pilih Hadiah';
            Navigator.of(context).pop(true);
            var berhasil = "Data pengajuan hadiah berhasil di kirim";
            WidgetAlert.showToast(context, berhasil);
            kirimPesanWaPengajuanHadiah(kedaiTerpilih[0]['no_telpon']);
          } else {
            Navigator.of(context).pop(true);
            WidgetAlert.showAlertUmum(context, message);
            print("$message");
          }
        });
      } catch (e) {
        setState(() {
          WidgetAlert.showAlertUmum(context, e);
        });
      }
    }
  }

  kirimPesanWaPengajuanHadiah(nohp) async {
    try {
      var response = await dio.Dio().get(
        Api.getPesanWa,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      setState(() {
        if (status == true) {
          var getPesan = data[1];
          _launcherWaKirim(getPesan, nohp);
        }
      });
    } catch (e) {
      print(e);
      // WidgetAlert.showAlertUmum(context, e);
    }
  }

  _launcherWaKirim(getPesan, nohp) async {
    var isiPesan = getPesan['isi_pesan'];
    var namaHadiah = hadiahTerpilih[0]['nama_hadiah'];
    var pointHadiah = hadiahTerpilih[0]['point_hadiah'];
    var gabunganPesan = "$isiPesan $namaHadiah $pointHadiah POINT";
    var notujuan = nohp;
    var filternohp = notujuan.substring(1);
    var kodeNegara = 62;
    var gabungNohp = "$kodeNegara$filternohp";
    print(gabunganPesan);
    print(gabungNohp);
    var whatsappURl_android =
        "whatsapp://send?phone=" + gabungNohp + "&text=" + gabunganPesan;
    await launch(whatsappURl_android);
    setState(() {
      kedaiTerpilih.clear();
      hadiahTerpilih.clear();
      namaHadiah = 'Pilih Hadiah';
    });
  }

  aksiKirimPemberianHadiah() async {
    if (kedaiPenukaranTerpilih.isEmpty) {
      var alert = "Harap lengkapi form pengajuan bagian kedai";
      WidgetAlert.showToast(context, alert);
    } else if (base64LaporanMemberikanHadiah == null) {
      var alert = "Harap lengkapi form pengajuan bagian upload gambar";
      WidgetAlert.showToast(context, alert);
    } else {
      WidgetAlert.showLoadingIndicator(context);

      try {
        var formData = dio.FormData.fromMap({
          "id_motoris": AppData.userId,
          "id_record_hadiah": kedaiPenukaranTerpilih[0]['id_record_hadiah'],
          "url_gambar": base64LaporanMemberikanHadiah
        });
        var response = await dio.Dio().post(
          Api.kirimPenukaranHadiah,
          data: formData,
        );
        var data = response.data['data'];
        var status = response.data['status'];
        var message = response.data['message'];
        setState(() {
          if (status == true) {
            Navigator.of(context).pop(true);
            var berhasil = "Data laporan hadiah berhasil di kirim";
            WidgetAlert.showToast(context, berhasil);
            var idKedaiTerpilihPemberianHadiah =
                kedaiPenukaranTerpilih[0]['id_kedai'];
            getNomorWaPemberianHadiah(idKedaiTerpilihPemberianHadiah);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  getNomorWaPemberianHadiah(idKedaiTerpilihPemberianHadiah) async {
    try {
      var formData =
          dio.FormData.fromMap({"id_kedai": idKedaiTerpilihPemberianHadiah});
      var response = await dio.Dio().post(
        Api.detailKedai,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("masuk kadie");
      print(data);
      setState(() {
        if (status == true) {
          var nohp = data[0]['no_telpon'];
          getPesanUntukMemberikanHadiah(nohp);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  getPesanUntukMemberikanHadiah(nohp) async {
    try {
      var response = await dio.Dio().get(
        Api.getPesanWa,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];
      setState(() {
        if (status == true) {
          var getPesan = data[2];
          print("masuk sini 1");
          // _launcherWaKirimMemberikanHadiah(getPesan, nohp);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _launcherWaKirimMemberikanHadiah(getPesan, nohp) async {
    var isiPesan = getPesan['isi_pesan'];
    var namaHadiah = kedaiPenukaranTerpilih[0]['nama_hadiah'];
    var pointHadiah = kedaiPenukaranTerpilih[0]['point_hadiah'];
    var gabunganPesan = "$isiPesan $namaHadiah $pointHadiah POINT";
    var notujuan = nohp;
    var filternohp = notujuan.substring(1);
    var kodeNegara = 62;
    var gabungNohp = "$kodeNegara$filternohp";
    print(gabunganPesan);
    print(gabungNohp);
    var whatsappURl_android =
        "whatsapp://send?phone=" + gabungNohp + "&text=" + gabunganPesan;
    await launch(whatsappURl_android);
    print("masuk sini 2");
    setState(() {
      kedaiPenukaranTerpilih.clear();
      fotoLaporanMemberikanHadiah = null;
      base64LaporanMemberikanHadiah = '';
    });
  }

  // WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET WIDGET

  Widget logo() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_logo_web.png"),
      ),
    );
  }

  Widget gambarSaset() {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset("assets/gambar/ic_saset_web.png"),
      ),
    );
  }

  Widget viewHadiah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 10,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                splashColor: Color.fromARGB(255, 224, 63, 51),
                onTap: () {
                  setState(() {
                    menuTerpilih = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      "Form Pengajuan Hadiah",
                      textAlign: TextAlign.center,
                      style: menuTerpilih == 0
                          ? TextStyle(
                              color: Color.fromARGB(255, 82, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 14)
                          : TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    menuTerpilih = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      "Laporan Penukaran Hadiah",
                      textAlign: TextAlign.center,
                      style: menuTerpilih == 1
                          ? TextStyle(
                              color: Color.fromARGB(255, 82, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 14)
                          : TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
        menuTerpilih == 1
            ? Expanded(
                flex: 90,
                child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            penukaranHadiah();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text("Pilih Kedai"),
                            ),
                          ),
                        ),
                        kedaiPenukaranTerpilih.isEmpty
                            ? SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "* ${kedaiPenukaranTerpilih[0]['nama_kedai']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "* ${kedaiPenukaranTerpilih[0]['alamat_kedai']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "* Point ${kedaiPenukaranTerpilih[0]['point']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "* Penukaran ${kedaiPenukaranTerpilih[0]['nama_hadiah']} - ${kedaiPenukaranTerpilih[0]['point_hadiah']} Point",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Upload Gambar Penyerahan Hadiah",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              getImageLaporanPemberianHadiah();
                            });
                          },
                          child: fotoLaporanMemberikanHadiah == null
                              ? Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/gambar/blur-image.jpg"),
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  child: Image.file(
                                    fotoLaporanMemberikanHadiah!,
                                    height: 200,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              var title = 'laporanMemberikanHadiah';
                              validasiKirim(title);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Center(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Kirim")),
                            ),
                          ),
                        )
                      ],
                    ))),
              )
            : Expanded(
                flex: 90,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialogAllKedai();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text("Pilih Kedai"),
                            ),
                          ),
                        ),
                        kedaiTerpilih.isEmpty
                            ? SizedBox()
                            : Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      margin: const EdgeInsets.only(left: 10),
                                      child: kedaiTerpilih[0]['gambar_kedai'] ==
                                              ''
                                          ? Image.network(Api.controllerAssets +
                                              'nothing.png')
                                          : Image.network(Api.controllerGambar +
                                              kedaiTerpilih[0]['gambar_kedai']),
                                    ),
                                    Text(
                                      kedaiTerpilih[0]['nama_kedai'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      kedaiTerpilih[0]['alamat_kedai'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "Tanggal bergabung ${DateFormat('dd MMMM y').format(DateFormat('yyyy-MM-dd').parse(kedaiTerpilih[0]['tanggal_daftar']))}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Point ${kedaiTerpilih[0]['point']}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () => dialogHadiah(),
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Center(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(namaHadiah)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              var title = 'formPengajuan';
                              validasiKirim(title);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Center(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Kirim")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
      ],
    );
  }

  showDialogAllKedai() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 90,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Cari Kedai...',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (text) {
                                    text = text.toLowerCase();
                                    setState(() {
                                      // ignore: avoid_function_literals_in_foreach_calls
                                      allKedaiPerIdClusterDisplay =
                                          allKedaiPerIdCluster.where((kedai) {
                                        var namaKedai =
                                            kedai['nama_kedai'].toLowerCase();
                                        return namaKedai.contains(text);
                                      }).toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 90, child: listKedaiSearch()),
                  ],
                ),
              ),
            );
          });
        });
  }

  penukaranHadiah() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 90,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Cari Kedai...',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (text) {
                                    text = text.toLowerCase();
                                    setState(() {
                                      // ignore: avoid_function_literals_in_foreach_calls
                                      kedaiPenukaranDisplay =
                                          kedaiPenukaran.where((kedai) {
                                        var namaKedai =
                                            kedai['nama_kedai'].toLowerCase();
                                        return namaKedai.contains(text);
                                      }).toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 90,
                      child: kedaiPenukaranDisplay.length != 0
                          ? listKedaiPenukaran()
                          : Center(
                              child: Text("Data belum tersedia"),
                            ),
                    ),
                    Divider(
                      height: 1.5,
                      color: Color.fromARGB(255, 122, 121, 121),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  dialogHadiah() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 90,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Cari Hadiah...',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  onChanged: (text) {
                                    text = text.toLowerCase();
                                    setState(() {
                                      // ignore: avoid_function_literals_in_foreach_calls
                                      listHadiahDisplay =
                                          listHadiah.where((hadiah) {
                                        var namaHadiah =
                                            hadiah['nama_hadiah'].toLowerCase();
                                        return namaHadiah.contains(text);
                                      }).toList();
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex: 90, child: viewListHadiah())
                  ],
                ),
              ),
            );
          });
        });
  }

  validasiKirim(title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text("Apakah semua data sudah benar...?"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 3, 3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (title == 'formPengajuan') {
                                    Navigator.pop(context, true);
                                    aksiKirimLaporan();
                                  } else if (title ==
                                      'laporanMemberikanHadiah') {
                                    Navigator.pop(context, true);
                                    aksiKirimPemberianHadiah();
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "Kirim",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        });
  }

  Widget listKedaiSearch() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: allKedaiPerIdClusterDisplay.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        kedaiTerpilih.clear();
                        var idKedai =
                            allKedaiPerIdClusterDisplay[index]['id_kedai'];
                        for (var i = 0;
                            i < allKedaiPerIdClusterDisplay.length;
                            i++) {
                          if (allKedaiPerIdClusterDisplay[i]['id_kedai'] ==
                              idKedai) {
                            kedaiTerpilih.add(allKedaiPerIdClusterDisplay[i]);
                          }
                        }
                        Navigator.pop(context, true);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 30,
                            child: Container(
                              height: 120,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              margin: const EdgeInsets.only(left: 10),
                              child: allKedaiPerIdClusterDisplay[index]
                                          ['gambar_kedai'] ==
                                      ''
                                  ? Image.network(
                                      Api.controllerAssets + 'nothing.png')
                                  : Image.network(Api.controllerGambar +
                                      allKedaiPerIdClusterDisplay[index]
                                          ['gambar_kedai']),
                            ),
                          ),
                          Expanded(
                              flex: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 25),
                                      child: Text(
                                          allKedaiPerIdClusterDisplay[index]
                                              ['nama_kedai'])),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 8),
                                      child: Text(
                                          "${allKedaiPerIdClusterDisplay[index]['alamat_kedai']} = ${allKedaiPerIdClusterDisplay[index]['point']} Point"))
                                ],
                              ))
                        ],
                      ),
                    ),
                  )),
              Divider(
                height: 2,
                color: Color.fromARGB(255, 122, 121, 121),
              )
            ],
          );
        });
  }

  Widget listKedaiPenukaran() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: kedaiPenukaranDisplay.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        kedaiPenukaranTerpilih.clear();
                        var idRecordHadiah =
                            kedaiPenukaranDisplay[index]['id_record_hadiah'];
                        for (var i = 0; i < kedaiPenukaranDisplay.length; i++) {
                          if (kedaiPenukaranDisplay[i]['id_record_hadiah'] ==
                              idRecordHadiah) {
                            kedaiPenukaranTerpilih
                                .add(kedaiPenukaranDisplay[i]);
                          }
                        }
                        Navigator.pop(context, true);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 30,
                            child: Container(
                              height: 120,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              margin: const EdgeInsets.only(left: 10),
                              child: kedaiPenukaranDisplay[index]
                                          ['gambar_kedai'] ==
                                      ''
                                  ? Image.network(
                                      Api.controllerAssets + 'nothing.png')
                                  : Image.network(Api.controllerGambar +
                                      kedaiPenukaranDisplay[index]
                                          ['gambar_kedai']),
                            ),
                          ),
                          Expanded(
                              flex: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 25),
                                      child: Text(kedaiPenukaranDisplay[index]
                                          ['nama_kedai'])),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 15, top: 8),
                                      child: Text(
                                          "${kedaiPenukaranDisplay[index]['alamat_kedai']} = ${kedaiPenukaranDisplay[index]['point']} Point"))
                                ],
                              ))
                        ],
                      ),
                    ),
                  )),
              Divider(
                height: 2,
                color: Color.fromARGB(255, 122, 121, 121),
              )
            ],
          );
        });
  }

  Widget viewListHadiah() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: listHadiahDisplay.length,
        itemBuilder: (context, index) {
          return Container(
              margin: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    hadiahTerpilih.clear();
                    var idHadiah = listHadiahDisplay[index]['id_hadiah'];
                    for (var i = 0; i < listHadiahDisplay.length; i++) {
                      if (listHadiahDisplay[i]['id_hadiah'] == idHadiah) {
                        hadiahTerpilih.add(listHadiahDisplay[i]);
                        namaHadiah =
                            "${listHadiahDisplay[i]['nama_hadiah']} - ${listHadiahDisplay[i]['point_hadiah']} point";
                      }
                    }
                    Navigator.pop(context, true);
                  });
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          margin: const EdgeInsets.only(left: 10),
                          child: Image.network(Api.controllerGambarHadiah +
                              listHadiahDisplay[index]['gambar_hadiah']),
                        ),
                      ),
                      Expanded(
                          flex: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, top: 25),
                                  child: Text(
                                      listHadiahDisplay[index]['nama_hadiah'])),
                              Container(
                                  margin:
                                      const EdgeInsets.only(left: 15, top: 8),
                                  child: Text(
                                      "Point ${listHadiahDisplay[index]['point_hadiah']}"))
                            ],
                          ))
                    ],
                  ),
                ),
              ));
        });
  }
}
