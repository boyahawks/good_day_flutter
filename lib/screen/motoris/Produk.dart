// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/adapter.dart';
import 'package:flutter/services.dart';
import 'package:good_day/screen/agen/Informasi_selesai_pembelian.dart';
import 'package:good_day/screen/motoris/Informasi_selesai_kunjungan.dart';
import 'package:good_day/screen/motoris/Kedai.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:good_day/utils/Data_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/Motoris.dart';
import '../../widget/Alert.dart';
import '../../utils/Api.dart';
import '../../widget/Alert.dart';

class Produk extends StatefulWidget {
  @override
  State<Produk> createState() => _ProdukinState();

  var kedai, pointBranding, pointHanger, statusKedai;
  Produk(
    this.kedai,
    this.pointBranding,
    this.pointHanger,
    this.statusKedai,
  );
}

class _ProdukinState extends State<Produk> {
  // final GlobalKey _scaffoldKey = new GlobalKey();

  _ProdukinState createState() => _ProdukinState();

  TextEditingController jumlahPilih = TextEditingController();
  final controller = Get.put(MotorisController());

  var produk = [];
  int pointGabunganLaporan = 0;
  int produkTerpilih = 0;
  String kodeProdukTerpilih = '';

  @override
  void initState() {
    pointGabunganLaporan = widget.pointBranding + widget.pointHanger;
    getDataProduk();
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
              child: produk.isEmpty
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
                          child: viewProduk(),
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
        floatingActionButton: Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: 6),
          child: Stack(
            children: [
              FloatingActionButton(
                child: Icon(
                  Icons.shopping_bag,
                  size: 40,
                  color: Color.fromARGB(255, 201, 13, 0),
                ),
                backgroundColor: Color.fromARGB(255, 250, 250, 250),
                onPressed: () {
                  setState(() {
                    print("akumulasi belanjaan");
                    kodeProdukTerpilih = '';
                    akumulasi();
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  "$produkTerpilih",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI FUNGSI
  getDataProduk() async {
    try {
      var response = await dio.Dio().get(Api.allProduk);
      var data = response.data['data'];
      var status = response.data['status'];
      var message = response.data['message'];

      setState(() {
        if (status == true) {
          for (var i = 0; i < data.length; i++) {
            var getFilter = [
              {
                "id_produk": data[i]['id_produk'],
                "nama_produk": data[i]['nama_produk'],
                "gambar_produk": data[i]['gambar_produk'],
                "type_produk": data[i]['type_produk'],
                "kode": data[i]['kode'],
                "jumlahPilih": "0",
              }
            ];
            produk.addAll(getFilter);
          }
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

  updateJumlah(idProduk) {
    setState(() {
      var terpilih = [];
      produk.forEach((element) {
        if (element['id_produk'] == idProduk) {
          element['jumlahPilih'] = jumlahPilih.text;
        }
      });
      for (var i = 0; i < produk.length; i++) {
        if (produk[i]['jumlahPilih'] != "0") {
          terpilih.add(produk[i]);
        }
      }
      jumlahPilih.text = "";
      produkTerpilih = terpilih.length;
    });
  }

  resetJumlah(idProduk) {
    setState(() {
      var terpilih = [];
      produk.forEach((element) {
        if (element['id_produk'] == idProduk) {
          element['jumlahPilih'] = "0";
        }
      });

      for (var i = 0; i < produk.length; i++) {
        if (produk[i]['jumlahPilih'] != "0") {
          terpilih.add(produk[i]);
        }
      }
      produkTerpilih = terpilih.length;
    });
  }

  akumulasi() {
    var produkPilihan = [];
    for (var i = 0; i < produk.length; i++) {
      if (int.parse(produk[i]['jumlahPilih']) > 0) {
        var filter = {
          'nama_produk': produk[i]['nama_produk'],
          'type_produk': produk[i]['type_produk'],
          'kode': produk[i]['kode'],
          'jumlahPilih': produk[i]['jumlahPilih'],
        };
        produkPilihan.add(filter);
      }
    }
    print("$produkPilihan");
    hitungPointFilter(produkPilihan);
  }

  hitungPointFilter(produkPilihan) {
    var getData = '';
    var dataPBK = 0;

    for (var i = 0; i < produkPilihan.length; i++) {
      if (produkPilihan[i]['kode'] != 'pbk') {
        if (getData == '') {
          getData = '${produkPilihan[i]['kode']}';
        } else {
          getData = '$getData,${produkPilihan[i]['kode']}';
        }
      }
      if (produkPilihan[i]['kode'] == 'pbk') {
        dataPBK += int.parse(produkPilihan[i]['jumlahPilih']);
      }
    }
    if ('$getData' != '') {
      var point = 0;
      print("ini kondisi 0 $getData");
      // KONDISI 1
      if ('$getData' == 'p3,p5' || '$getData' == 'p4,p5') {
        if (produkPilihan[0]['jumlahPilih'] == '1' &&
            produkPilihan[1]['jumlahPilih'] == '1') {
          print('beli satu semua');
          point += 300;
        } else {
          // ignore: deprecated_member_use
          List names = [];
          var status = 0;
          produkPilihan.forEach((u) {
            if (names.contains(u["jumlahPilih"]))
              // ignore: curly_braces_in_flow_control_structures
              status = 1;
            else
              // ignore: curly_braces_in_flow_control_structures
              names.add(u["jumlahPilih"]);
          });
          print("$names");
          if (status != 0) {
            var pilihan = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              pilihan = int.parse(produkPilihan[i]['jumlahPilih']);
            }
            print("$pilihan");
            var pointSementara = 300;
            var updatePilihan = pilihan - 1;
            var hitungPilihan = 200 * updatePilihan;
            var updatePointSementara = pointSementara + hitungPilihan;
            point = updatePointSementara;
          } else {
            for (var i = 0; i < produkPilihan.length; i++) {
              point += 100 * int.parse(produkPilihan[i]['jumlahPilih']);
            }
          }
        }
      }
      // KONDISI 2
      else if ('$getData' == 'p1,p5' || '$getData' == 'p2,p5') {
        if (produkPilihan[0]['jumlahPilih'] == '1' &&
            produkPilihan[1]['jumlahPilih'] == '1') {
          print('beli satu semua');
          point += 400;
        } else {
          // ignore: deprecated_member_use
          List names = [];
          var status = 0;
          produkPilihan.forEach((u) {
            if (names.contains(u["jumlahPilih"]))
              // ignore: curly_braces_in_flow_control_structures
              status = 1;
            else
              // ignore: curly_braces_in_flow_control_structures
              names.add(u["jumlahPilih"]);
          });
          print("$names");
          if (status != 0) {
            var pilihan = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              pilihan = int.parse(produkPilihan[i]['jumlahPilih']);
            }
            print("$pilihan");
            var pointSementara = 400;
            var updatePilihan = pilihan - 1;
            var hitungPilihan = 300 * updatePilihan;
            var updatePointSementara = pointSementara + hitungPilihan;
            point = updatePointSementara;
          } else {
            var tampungPoint = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              if (produkPilihan[i]['type_produk'] == "1") {
                tampungPoint +=
                    200 * int.parse(produkPilihan[i]['jumlahPilih']);
              } else if (produkPilihan[i]['type_produk'] == "2") {
                tampungPoint +=
                    100 * int.parse(produkPilihan[i]['jumlahPilih']);
              }
            }
            point = tampungPoint;
          }
        }
      }
      // KONDISI 3
      else if ('$getData' == 'p1,p5,p6' ||
          '$getData' == 'p2,p5,p6' ||
          '$getData' == 'p1,p5,p7' ||
          '$getData' == 'p2,p5,p7') {
        if (produkPilihan[0]['jumlahPilih'] == '1' &&
            produkPilihan[1]['jumlahPilih'] == '1' &&
            produkPilihan[2]['jumlahPilih'] == '1') {
          print('beli satu semua');
          point += 500;
        } else {
          // ignore: deprecated_member_use
          List names = [];
          var status = 0;
          produkPilihan.forEach((u) {
            if (names.contains(u["jumlahPilih"]))
              // ignore: curly_braces_in_flow_control_structures
              status = 1;
            else
              // ignore: curly_braces_in_flow_control_structures
              names.add(u["jumlahPilih"]);
          });
          print("$names");
          if (status != 0) {
            var pilihan = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              pilihan = int.parse(produkPilihan[i]['jumlahPilih']);
            }
            print("$pilihan");
            var pointSementara = 500;
            var updatePilihan = pilihan - 1;
            var hitungPilihan = 400 * updatePilihan;
            var updatePointSementara = pointSementara + hitungPilihan;
            point = updatePointSementara;
          } else {
            print("masuk sini");
            var tampungPoint = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              if (produkPilihan[i]['type_produk'] == "1") {
                tampungPoint +=
                    200 * int.parse(produkPilihan[i]['jumlahPilih']);
              } else if (produkPilihan[i]['type_produk'] == "2") {
                tampungPoint +=
                    100 * int.parse(produkPilihan[i]['jumlahPilih']);
              }
            }
            point = tampungPoint;
          }
        }
      }
      // KONDISI 4
      else if ('$getData' == 'p1,p2,p5') {
        if (produkPilihan[0]['jumlahPilih'] == '1' &&
            produkPilihan[1]['jumlahPilih'] == '1' &&
            produkPilihan[2]['jumlahPilih'] == '1') {
          print('beli satu semua');
          point += 600;
        } else {
          // ignore: deprecated_member_use
          List names = [];
          var status = 0;
          produkPilihan.forEach((u) {
            if (names.contains(u["jumlahPilih"]))
              // ignore: curly_braces_in_flow_control_structures
              status = 1;
            else
              // ignore: curly_braces_in_flow_control_structures
              names.add(u["jumlahPilih"]);
          });
          print("$names");
          if (status != 0) {
            var pilihan = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              pilihan = int.parse(produkPilihan[i]['jumlahPilih']);
            }
            print("$pilihan");
            var pointSementara = 600;
            var updatePilihan = pilihan - 1;
            var hitungPilihan = 500 * updatePilihan;
            print("dapet nih $hitungPilihan");
            var updatePointSementara = pointSementara + hitungPilihan;
            point = updatePointSementara;
          } else {
            print("masuk sini");
            var tampungPoint = 0;
            for (var i = 0; i < produkPilihan.length; i++) {
              if (produkPilihan[i]['type_produk'] == "1") {
                tampungPoint +=
                    200 * int.parse(produkPilihan[i]['jumlahPilih']);
              } else if (produkPilihan[i]['type_produk'] == "2") {
                tampungPoint +=
                    100 * int.parse(produkPilihan[i]['jumlahPilih']);
              }
            }
            point = tampungPoint;
          }
        }
      } else {
        print("kaga masuk semua kondisi");
        var tampungPoint = 0;
        for (var i = 0; i < produkPilihan.length; i++) {
          if (produkPilihan[i]['type_produk'] == "1") {
            tampungPoint += 200 * int.parse(produkPilihan[i]['jumlahPilih']);
          } else if (produkPilihan[i]['type_produk'] == "2") {
            tampungPoint += 100 * int.parse(produkPilihan[i]['jumlahPilih']);
          }
        }
        point = tampungPoint;
      }
      print("$point");
      print("$dataPBK");
      hitungFinal(point, dataPBK, produkPilihan);
    }
  }

  hitungFinal(point, dataPBK, produkPilihan) {
    controller.listProdukTerpilih = produkPilihan;
    if (dataPBK == 0) {
      var pointPembelian = point + dataPBK;
      validasiSimpan(pointPembelian);
    } else {
      var hitung = dataPBK * 1500;
      var pointPembelian = point + hitung;
      validasiSimpan(pointPembelian);
    }
  }

  validasiSimpan(pointPembelian) {
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
                    "Selesaikan pembelian ?",
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
                  print("${controller.listProdukTerpilih}");
                  if (widget.statusKedai == 'roleGrosir') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformasiSelesaiPembelian(
                              widget.kedai,
                              0,
                              0,
                              widget.statusKedai,
                              pointPembelian)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformasiSelesaiKunjungan(
                              widget.kedai,
                              widget.pointBranding,
                              widget.pointHanger,
                              widget.statusKedai,
                              pointPembelian)),
                    );
                  }
                });
              },
            )
          ],
        );
      },
    );
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

  Widget viewProduk() {
    return SizedBox(
      height: 480,
      child: GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: produk.length,
          scrollDirection:
              produk.length - 1 > 10 ? Axis.horizontal : Axis.vertical,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: produk.length - 1 > 10 ? 130 : 200,
              childAspectRatio: produk.length - 1 > 10 ? 2 / 4 : 5 / 5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 15, left: 15),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          Api.controllerGambarSaset +
                              produk[index]['gambar_produk'],
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            // decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //   alignment: Alignment.center,
                            //   image: NetworkImage(
                            //     Api.controllerGambarSaset +
                            //         produk[index]['gambar_produk'],
                            //   ),
                            // )),
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (produk[index]['jumlahPilih'] != '0') {
                                        jumlahPilih.text =
                                            produk[index]['jumlahPilih'];
                                      } else {
                                        jumlahPilih.text = '';
                                      }
                                      kodeProdukTerpilih = '';
                                      var idProduk = produk[index]['id_produk'];
                                      getJumlah(idProduk);
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        produk[index]['jumlahPilih'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                    Text(
                      produk[index]['nama_produk'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  void getJumlah(idProduk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'jumlah'),
                      controller: jumlahPilih,
                    ),
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
              child: Text("Reset"),
              onPressed: () {
                setState(() {
                  resetJumlah(idProduk);
                  Navigator.pop(context, true);
                });
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  updateJumlah(idProduk);
                  Navigator.pop(context, true);
                });
              },
            )
          ],
        );
      },
    );
  }
}
