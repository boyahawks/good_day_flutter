// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:good_day/screen/motoris/Kunjungan.dart';
import 'package:good_day/screen/motoris/Laporan.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class DetailKedai extends StatefulWidget {
  @override
  State<DetailKedai> createState() => _DetailKedaiinState();

  // ignore: prefer_typing_uninitialized_variables
  var kedai;
  // ignore: use_key_in_widget_constructors
  DetailKedai(this.kedai);
}

class _DetailKedaiinState extends State<DetailKedai> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _DetailKedaiinState createState() => _DetailKedaiinState();

  List detailKedai = [];

  bool sudahDekat = false;

  @override
  void initState() {
    getDetailKedai();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                  flex: 20,
                  child: logo(),
                ),
                Expanded(
                  flex: 65,
                  child: viewKedai(),
                ),
                Expanded(
                  flex: 15,
                  child: gambarSaset(),
                )

                // bioKedai(),
                // SizedBox(
                //   height: 20,
                // ),
                // mulaiKunjungan(),
              ],
            ),
    ));
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getDetailKedai() async {
    print(widget.kedai);
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

  akumulasi() async {
    // var idKedai = detailKedai[0]['id_kedai'];
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Laporan(idKedai)),
    // );
    WidgetAlert.showLoadingIndicator(context);

    if (detailKedai[0]['lat'] == '' || detailKedai[0]['lang'] == '') {
      setState(() {
        var berhasil =
            "Terjadi kesalahan lat dan lang kosong... harap hubungi admin";
        WidgetAlert.showToast(context, berhasil);
        Navigator.pop(context, true);
      });
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      var latMotoris = position.latitude;
      var langMotoris = position.longitude;
      // var latMotoris = -7.3100583;
      // var langMotoris = 112.7834255;
      var from = Point(latMotoris, langMotoris);
      updateLokasiMotoris(latMotoris, langMotoris);

      var homeLat = detailKedai[0]['lat'];
      var homeLng = detailKedai[0]['lang'];
      var to = Point(double.parse(homeLat), double.parse(homeLng));

      double distance = SphericalUtils.computeDistanceBetween(from, to);
      print('Distance: $distance meters');
      var filter = double.parse((distance).toStringAsFixed(0));

      // var berhasil = "$filter meters";
      // WidgetAlert.showToast(context, berhasil);-7.31029801,112.7837365
      if (filter <= 1000.0) {
        print("sudah dekat");
        var idKedai = detailKedai[0]['id_kedai'];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Laporan(idKedai)),
        );
      } else {
        print("masih jauh");
        var berhasil = "Harap dekati kedai yang di kunjungi...";
        WidgetAlert.showToast(context, berhasil);
        Navigator.pop(context, true);
      }
      // var idKedai = detailKedai[0]['id_kedai'];
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Laporan(idKedai)),
      // );
    }
  }

  updateLokasiMotoris(latMotoris, langMotoris) async {
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
        "lat": "$latMotoris",
        "lang": "$langMotoris",
      });
      var response = await dio.Dio().post(
        Api.updateLokasiMotoris,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");
    } on Exception catch (e) {
      setState(() {
        var gagal = "terjadi kesalahan update lokasi";
        WidgetAlert.showToast(context, gagal);
      });
    }
  }

  updateDestinasiMotoris(homeLat, homeLng) async {
    try {
      var formData = dio.FormData.fromMap({
        "user_id": AppData.userId,
        "lat_destinasi": "$homeLat",
        "lang_destinasi": "$homeLng",
      });
      var response = await dio.Dio().post(
        Api.updateDestinasiMotoris,
        data: formData,
      );
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      print("$data");
    } on Exception catch (e) {
      setState(() {
        var gagal = "terjadi kesalahan update lokasi";
        WidgetAlert.showToast(context, gagal);
      });
    }
  }

  redirectGmaps() async {
    String homeLat = detailKedai[0]['lat'];
    String homeLng = detailKedai[0]['lang'];
    updateDestinasiMotoris(homeLat, homeLng);
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
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

  Widget viewKedai() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 70, child: bioKedai()),
        Expanded(flex: 30, child: mulaiKunjungan()),
      ],
    );
  }

  Widget bioKedai() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  margin: const EdgeInsets.only(left: 10),
                  child: detailKedai[0]['gambar_kedai'] == ''
                      ? Image.network(Api.controllerAssets + 'nothing.png')
                      : Image.network(Api.controllerGambar +
                          detailKedai[0]['gambar_kedai']),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            detailKedai[0]['nama_kedai'],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            detailKedai[0]['alamat_kedai'],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Tanggal bergabung ${DateFormat('dd MMMM y').format(DateFormat('yyyy-MM-dd').parse(detailKedai[0]['tanggal_daftar']))}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget mulaiKunjungan() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                    height: 80,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            print("mulai kunjungan");
                            redirectGmaps();
                          });
                        },
                        child: Image.asset("assets/gambar/icon1.png"))),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "Mulai Berkunjung",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                    height: 80,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            print("mulai akumulasi");
                            akumulasi();
                          });
                        },
                        child: Image.asset("assets/gambar/icon2.png"))),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    "Laporan",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
